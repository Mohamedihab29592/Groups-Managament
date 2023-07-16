const functions = require("firebase-functions");
const admin = require("firebase-admin");
const moment = require("moment-timezone");
const cron = require("node-cron");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://vodafone-follow-up.firebaseio.com/",
});
async function scheduleTaskNotification(taskData)
{
  const notificationTime = taskData.timeStamp ? taskData.timeStamp.toDate() : null;
  const body = taskData.title;
  const group = taskData.group;
  const critical = taskData.critical;
  if (notificationTime === null)
  {
    console.log("Invalid notification time:", notificationTime);
    return;
  }

  const timezone = "Etc/GMT-3"; // set the user's time zone here
  const notificationMoment = moment.tz(notificationTime, timezone);
  const nowMoment = moment.tz(Date.now(), timezone);
  const delay = notificationMoment.diff(nowMoment, "milliseconds");

  if (delay <= 0)
  {
    console.log("Invalid delay:", delay);
    return;
  }

  const startDelay = moment
      .duration({
        minutes: 60 - nowMoment.minutes(),
        seconds: 60 - nowMoment.seconds(),
      })
      .asMilliseconds();

  console.log(`Scheduling notification in ${startDelay}ms ${taskData.id}`);

  // Schedule the notification using a cron job
  cron.schedule(
      notificationMoment.format("m H D M d"),
      async function ()
      {
        console.log("cron.schedule start!");
        await sendNotification(body, group);
        console.log("Notification sent!");
        if (critical === 1)
        {
          await sendNotification(body, "All");
        }
      },
      {
        scheduled: true,
        timezone: timezone,
      },
  );
}
async function sendNotification(body, group)
{
  const payload = {
    notification: {
      title: "Follow UP",
      body: body,

    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
  };

  await admin.messaging().sendToTopic(group, payload);
}
exports.scheduleNotification = functions.firestore
    .document("tasks/{taskId}")
    .onCreate(async (snapshot, context) =>
    {
      const data = snapshot.data();
      const body = data.title;
      const time = data.time;
      const date = data.date;
      const group = data.group;

      const payload = {
        notification: {
          title: body + " (New Task Created)",
          body: "Follow up On " + date + " at " + time,
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      await admin.messaging().sendToTopic(group, payload);

      await scheduleTaskNotification(data);
    });

exports.updateTask = functions.firestore
    .document("tasks/{taskId}")
    .onUpdate(async (change, context) =>
    {
      const taskData = change.after.data();
      const oldTaskData = change.before.data();
      const body = taskData.title;
      const time = taskData.time;
      const date = taskData.date;
      const group = taskData.group;
      const payload = {
        notification: {
          title: body + " (Task Updated)",
          body: "Follow up On " + date + " at " + time,
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      await admin.messaging().sendToTopic(group, payload);

      const oldNotificationTime = oldTaskData.timeStamp ?
      oldTaskData.timeStamp.toDate() :
      null;
      const newNotificationTime = taskData.timeStamp ?
      taskData.timeStamp.toDate() :
      null;

      if (!oldNotificationTime || !newNotificationTime)
      {
        console.log(
            "Invalid notification time:",
            oldNotificationTime,
            newNotificationTime,
        );
        return;
      }

      // Check if notification time or date has changed
      if (oldNotificationTime.getTime() !== newNotificationTime.getTime())
      {
        console.log("Notification time has changed");
        await scheduleTaskNotification(taskData);
        console.log(`New notification for task ${taskData.id} scheduled`);
      }
    });
