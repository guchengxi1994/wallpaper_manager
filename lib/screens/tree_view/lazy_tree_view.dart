// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:path/path.dart' as path;

class LazyTreeview extends StatefulWidget {
  const LazyTreeview({super.key});

  @override
  State<LazyTreeview> createState() => _LazyTreeviewState();
}

class _LazyTreeviewState extends State<LazyTreeview> {
  late final TreeController<GalleryOrWallpaper> treeController;

  final Set<int> loadingIds = {};
  final Map<int, List<GalleryOrWallpaper>> childrenMap = {};

  Future loadChildren(GalleryOrWallpaper galleryOrWallpaper) async {
    galleryOrWallpaper.map(gallery: (g) async {
      setState(() {
        loadingIds.add(g.field0.galleryId);
      });
      childrenMap[g.field0.galleryId] =
          await api.getChildrenById(i: g.field0.galleryId);
      loadingIds.remove(g.field0.galleryId);
      if (mounted) setState(() {});

      treeController.expand(galleryOrWallpaper);
    }, wallPaper: (w) {
      return;
    });
  }

  @override
  void dispose() {
    try {
      treeController.dispose();
    } catch (_) {}

    super.dispose();
  }

  getRoot() async {
    final children = await api.getChildrenById(i: 0);
    debugPrint("[flutter-root-length]:${children.length}");
    // treeController.expand(node)
    setState(() {
      treeController.roots = children;
    });
  }

  Widget getLeadingFor(GalleryOrWallpaper galleryOrWallpaper) {
    return galleryOrWallpaper.map(gallery: (data) {
      if (loadingIds.contains(data.field0.galleryId)) {
        return const Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }

      late final VoidCallback? onPressed;
      late final bool? isOpen;

      final List<GalleryOrWallpaper>? children =
          childrenMap[data.field0.galleryId];

      if (children == null) {
        isOpen = false;
        onPressed = () => loadChildren(data);
      } else if (children.isEmpty) {
        isOpen = null;
        onPressed = null;
      } else {
        isOpen = treeController.getExpansionState(data);
        onPressed = () => treeController.toggleExpansion(data);
      }

      return FolderButton(
        key: GlobalObjectKey(data.field0.galleryId),
        isOpen: isOpen,
        onPressed: onPressed,
      );
    }, wallPaper: (w) {
      return const SizedBox(
        child: Icon(Icons.image),
      );
    });
  }

  Iterable<GalleryOrWallpaper> childrenProvider(GalleryOrWallpaper data) {
    return data.map(gallery: (g) {
      return childrenMap[g.field0.galleryId] ?? const Iterable.empty();
    }, wallPaper: (w) {
      return const Iterable.empty();
    });
  }

  @override
  void initState() {
    super.initState();
    treeController = TreeController(
        roots: const Iterable.empty(), childrenProvider: childrenProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getRoot();
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return AnimatedTreeView<GalleryOrWallpaper>(
      treeController: treeController,
      nodeBuilder: (_, TreeEntry<GalleryOrWallpaper> entry) {
        return TreeIndentation(
          entry: entry,
          child: Row(
            children: [
              SizedBox.square(
                dimension: 40,
                child: getLeadingFor(entry.node),
              ),
              // Text(entry.node.title),
              entry.node.map(gallery: (g) {
                // debugPrint(g.field0.galleryName);
                return Text(g.field0.galleryName);
              }, wallPaper: (w) {
                // debugPrint(w.field0.filePath);
                return Text(path.basename(w.field0.filePath));
              })
            ],
          ),
        );
      },
      padding: const EdgeInsets.all(8),
    );
  }
}
