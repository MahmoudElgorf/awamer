const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const SUPPORT_TEAM_ID = 'BWn8QAHBDKb4Eky29xYgd48iLGH3';

exports.sendSupportNotification = functions.firestore
  .document('support_chats/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();
    const { chatId } = context.params;

    try {
      // 1. الحصول على بيانات المحادثة
      const chatRef = admin.firestore().collection('support_chats').doc(chatId);
      const chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        console.log('Chat document not found');
        return;
      }

      const chatData = chatDoc.data();

      // 2. تحديد المرسل والمستقبل
      const senderId = messageData.senderId;
      const isFromSupport = senderId === SUPPORT_TEAM_ID;

      // 3. الحصول على بيانات المستقبل
      const receiverId = isFromSupport ? chatData.userId : SUPPORT_TEAM_ID;
      const userDoc = await admin.firestore()
        .collection('users')
        .doc(receiverId)
        .get();

      if (!userDoc.exists) {
        console.log('User document not found');
        return;
      }

      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) {
        console.log('No FCM token for receiver');
        return;
      }

      // 4. تحديث العداد غير المقروء
      if (!isFromSupport) {
        await chatRef.update({
          unreadCount: admin.firestore.FieldValue.increment(1),
          lastMessageTime: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      // 5. الحصول على اسم المرسل
      const senderDoc = await admin.firestore()
        .collection('users')
        .doc(senderId)
        .get();

      const senderName = senderDoc.exists
        ? `${senderDoc.data()?.firstName} ${senderDoc.data()?.lastName}`.trim()
        : 'مستخدم';

      // 6. إعداد محتوى الإشعار
      const notification = {
        title: isFromSupport ? 'رد من الدعم الفني' : `رسالة جديدة من ${senderName}`,
        body: (messageData.text || 'رسالة جديدة').substring(0, 100),
      };

      // 7. إرسال الإشعار
      await admin.messaging().send({
        token: fcmToken,
        notification: notification,
        data: {
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          chatId: chatId,
          type: 'support_chat',
          senderId: senderId,
        },
      });

      console.log('Notification sent successfully to:', receiverId);
    } catch (error) {
      console.error('Error sending notification:', error);
    }
  });