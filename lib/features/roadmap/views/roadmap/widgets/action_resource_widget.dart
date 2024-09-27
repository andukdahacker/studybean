import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionResourceWidget extends StatelessWidget {
  const ActionResourceWidget(
      {super.key, required this.resource, required this.onEditResource, required this.onDeleteResource});

  final ActionResource resource;
  final VoidCallback onEditResource;
  final VoidCallback onDeleteResource;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(resource.url));
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: resource.url));
                      context.pop();
                    },
                    child: const Text('Copy URL')),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    onEditResource();
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.showConfirmDialog(
                        title: 'Delete resource',
                        message:
                            'Are you sure you want to delete this resource?',
                        onConfirm: () {
                          onDeleteResource();
                        },
                      );
                    },
                    child: const Text('Delete')),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: context.containerDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resource.title,
                style: context.theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                resource.url,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(resource.description ?? 'No description'),
            ],
          ),
        ),
      ),
    );
  }
}
