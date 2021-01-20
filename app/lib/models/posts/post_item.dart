import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/posts_provider.dart';

class PostItem extends HookWidget {
  const PostItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _post = useProvider(currentPost);
    final itemFocusNode = useFocusNode();

    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
        color: Colors.white,
        elevation: 6,
        child: Focus(
          focusNode: itemFocusNode,
          onFocusChange: (focused) {
            focused
                ? textEditingController.text = _post.description
                : context.read(postsProvider).edit(
                    id: _post.id, description: textEditingController.text);
          },
          child: ListTile(
            onTap: () {
              itemFocusNode.requestFocus();
              textFieldFocusNode.requestFocus();
            },
            title: isFocused
                ? TextField(
                    autofocus: true,
                    focusNode: textFieldFocusNode,
                    controller: textEditingController,
                  )
                : Text(_post.description),
          ),
        ));
  }
}
