import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

import '../Utilities/selectable_item.dart';
import '../Utilities/selection_app_bar.dart';

class MultiSelectScreen extends StatefulWidget {
  @override
  MultiSelectScreenState createState() => MultiSelectScreenState();
}

class MultiSelectScreenState extends State<MultiSelectScreen> {
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SelectionAppBar(
        selection: controller.value,
      ),
      body: DragSelectGridView(
        gridController: controller,
        itemCount: 20,
        itemBuilder: (context, index, selected) {
          return SelectableItem(
              index: index,
              selected: selected,
              color: Colors.lightBlue,
              items: []);
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80,
        ),
      ),
    );
  }

  void scheduleRebuild() => setState(() {});
}
