import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jsm/jsm.dart';

import 'package:chat/models/message.dart';
import 'controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => ChatController(),
      builder: (context, controller) {
        return GestureDetector(
          onTap: () => controller.chatFocusNode.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: JObserverWidget<User?>(
                observable: controller.currentUser,
                onChange: (User? user) {
                  return Row(
                    children: [
                      (user != null) && (user.photoURL != null)
                          ? CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(user.photoURL!),
                              ),
                            )
                          : Container(),
                      const SizedBox(width: 10),
                      Text(user!.displayName!.split(' ')[0]),
                    ],
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: JObserverWidget(
                    observable: JTheme.currentTheme,
                    onChange: (ThemeData theme) {
                      return Icon(
                        theme == JTheme.lightTheme
                            ? Icons.mode_night_outlined
                            : Icons.wb_sunny_outlined,
                      );
                    },
                  ),
                  onPressed: () {
                    JTheme.toggleTheme();
                  },
                  splashRadius: 20,
                ),
                IconButton(
                  onPressed: () {
                    controller.onSignOut();
                  },
                  icon: const Icon(Icons.logout_outlined),
                  splashRadius: 20,
                ),
              ],
            ),
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) {
                  return;
                }
              },
              child: SafeArea(
                child: Column(
                  children: [
                    // MESSAGES LIST
                    controller.messages.observer(
                      (messages) => Expanded(
                        child: messages.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {},
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  reverse: true,
                                  controller: controller.scrollController,
                                  itemCount: messages.length,
                                  itemBuilder: ((context, index) {
                                    // ...
                                    final msg =
                                        Message.fromJson(messages[index]);
                                    return Builder(builder: (context) {
                                      bool me = msg.uid ==
                                          controller
                                              .firebase.currentUser.value!.uid;
                                      final u = controller.users[msg.uid];
                                      final dt =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              msg.createdAt
                                                  .millisecondsSinceEpoch);
                                      String hdt = timeago.format(dt);
                                      return ListTile(
                                        leading: me
                                            ? const SizedBox(width: 50)
                                            : CircleAvatar(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child:
                                                      Image.network(u!.photo),
                                                ),
                                              ),
                                        title: Text(
                                          msg.content,
                                          textAlign: me
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: me
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              u!.name,
                                              textAlign: me
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                            ),
                                            Text(hdt),
                                          ],
                                        ),
                                        trailing: me
                                            ? CircleAvatar(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.network(u.photo),
                                                ),
                                              )
                                            : const SizedBox(width: 50),
                                      );
                                    });
                                    // ...
                                  }),
                                ),
                              )
                            : controller.isLoadingData.observer(
                                (isLoadingData) => isLoadingData
                                    ? Container()
                                    : const Center(
                                        child: Text(
                                        'No messages',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                              ),
                      ),
                    ),
                    // BUTTOM BAR
                    Builder(builder: (context) {
                      Brightness brightness =
                          ThemeData.estimateBrightnessForColor(
                              Theme.of(context).scaffoldBackgroundColor);
                      Color? containerColor = brightness == Brightness.dark
                          ? Colors.black38
                          : Colors.black12;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: containerColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // TEXT FIELD
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: TextField(
                                  focusNode: controller.chatFocusNode,
                                  controller: controller.textEditingController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: 'Message',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // ICOND SEND
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              child: Builder(
                                builder: (context) {
                                  return InkWell(
                                    onTap: controller.onSendMessage,
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.send),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // ...
                          ],
                        ),
                      );
                    }),
                    // ...
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
