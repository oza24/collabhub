import 'package:flutter/material.dart';

class EditBioBottomSheet extends StatefulWidget {

  final String currentBio;
  final Function(String) onSave;

  const EditBioBottomSheet({
    super.key,
    required this.currentBio,
    required this.onSave,
  });

  @override
  State<EditBioBottomSheet> createState() => _EditBioBottomSheetState();
}

class _EditBioBottomSheetState extends State<EditBioBottomSheet> {

  late TextEditingController bioController;



  @override
  void initState() {
    super.initState();

    bioController = TextEditingController(text: widget.currentBio,);
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom:
        MediaQuery.of(context)
            .viewInsets
            .bottom +
            20,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "Edit Bio",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText:
              "Tell something about yourself",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {

                widget.onSave(
                  bioController.text.trim(),
                );

                Navigator.pop(context);
              },

              child: const Text(
                "Save",
              ),
            ),
          ),
        ],
      ),
    );
  }
}