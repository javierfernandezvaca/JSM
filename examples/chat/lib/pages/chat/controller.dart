import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import 'package:chat/models/person.dart';
import 'package:chat/services/firebase.dart';

class ChatController extends JController {
  final firebase = JService.find<FirebaseService>();
  late JObservable<User?> currentUser;

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode chatFocusNode = FocusNode();

  String usersCollectionPath = 'users';
  String messagesCollectionPath = 'messages';
  int chatPaginationLimit = 15;

  String messageIdLabel = 'id';
  String messageCreatedAtLabel = 'createdAt';
  String messageUpdatedAtLabel = 'updatedAt';
  String messageUserIdLabel = 'uid';
  String messageContentLabel = 'content';

  final messages = [].observable;
  bool moreDataIsAvailable = true;
  final isLoadingData = false.observable;
  bool dataPreload = false;
  late StreamSubscription snapshotsSubscription;
  DocumentSnapshot? lastDocument;
  final users = <String, Person>{};

  late CollectionReference<Map<String, dynamic>> messageCollectionReference;
  late CollectionReference<Map<String, dynamic>> usersCollectionReference;

  @override
  void onInit() {
    currentUser = firebase.currentUser;
    usersCollectionReference =
        FirebaseFirestore.instance.collection(usersCollectionPath);
    messageCollectionReference =
        FirebaseFirestore.instance.collection(messagesCollectionPath);
  }

  @override
  void onReady() async {
    await getUsers();
    getPaginatedData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getPaginatedData();
      }
    });
    onProcessChatEvents();
  }

  @override
  void onClose() {
    snapshotsSubscription.cancel();
  }

  void onSignOut() {
    JDialog.materialConfirmationDialog(
      title: const Text('Confirm'),
      content: const Text('Do you want to log out of the chat?'),
      confirmLabel: const Text('OK'),
      onConfirm: () async {
        await firebase.signOut();
        JRouter.offNamed(page: '/login');
      },
    );
  }

  Future<void> getUsers() async {
    QuerySnapshot querySnapshot = await usersCollectionReference.get();
    users.clear();
    for (var u in querySnapshot.docs) {
      final user = Person.fromJson(u.data() as Map<String, dynamic>);
      users[user.id] = user;
    }
  }

  Future<void> getPaginatedData() async {
    if (moreDataIsAvailable) {
      isLoadingData.value = true;
      // ...
      late QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await messageCollectionReference
            .orderBy(messageCreatedAtLabel, descending: true)
            .limit(chatPaginationLimit)
            .get();
      } else {
        querySnapshot = await messageCollectionReference
            .orderBy(messageCreatedAtLabel, descending: true)
            .limit(chatPaginationLimit)
            .startAfterDocument(lastDocument!)
            .get();
      }
      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
      }
      messages.value.addAll(querySnapshot.docs.map((e) => e.data()).toList());
      messages.refresh();
      isLoadingData.value = false;
      // ...
      if (querySnapshot.docs.length < chatPaginationLimit) {
        moreDataIsAvailable = false;
      }
    }
  }

  onProcessChatEvents() async {
    late final Query<Map<String, dynamic>> query;
    if (lastDocument == null) {
      query = messageCollectionReference
          .orderBy(messageCreatedAtLabel, descending: true)
          .limit(chatPaginationLimit);
    } else {
      query = messageCollectionReference
          .orderBy(messageCreatedAtLabel, descending: true)
          .limit(chatPaginationLimit)
          .startAfterDocument(lastDocument!);
    }
    snapshotsSubscription =
        query.snapshots(includeMetadataChanges: true).listen(
      (QuerySnapshot<Map<String, dynamic>> event) {
        if (!dataPreload) {
          dataPreload = true;
        } else {
          var docChanges = event.docChanges;
          for (var docChange in docChanges) {
            var type = docChange.type;
            if ((type == DocumentChangeType.added) &&
                (docChange.newIndex == 0)) {
              messages.value.insert(0, event.docs.first.data());
              messages.refresh();
            }
            if (type == DocumentChangeType.modified) {
              messages.value[docChange.oldIndex] =
                  event.docs[docChange.oldIndex].data();
              messages.refresh();
            }
            if (type == DocumentChangeType.removed) {
              messages.value.removeAt(docChange.oldIndex);
              messages.refresh();
            }
          }
        }
      },
    );
  }

  void onSendMessage() async {
    String text = textEditingController.text.trim();
    if (text.isNotEmpty) {
      final doc = messageCollectionReference.doc();
      final time = Timestamp.fromDate(DateTime.now());
      final msg = {
        messageIdLabel: doc.id,
        messageCreatedAtLabel: time,
        messageUpdatedAtLabel: time,
        messageUserIdLabel: currentUser.value!.uid,
        messageContentLabel: text,
      };
      textEditingController.clear();
      chatFocusNode.requestFocus();
      doc.set(msg);
      _gotoScrollPosition(offset: 0);
    }
  }

  void _gotoScrollPosition({
    required double offset,
    bool animated = true,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (scrollController.hasClients) {
      animated
          ? scrollController.animateTo(
              offset,
              duration: duration,
              curve: Curves.easeOut,
            )
          : scrollController.jumpTo(0);
    }
  }

  // ...
}
