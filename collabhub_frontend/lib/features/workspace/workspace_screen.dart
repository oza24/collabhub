
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

import 'widgets/workspace_card.dart';
import 'services/workspace_service.dart';
import 'workspace_detail_screen.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  List workspaces = [];
  List filteredWorkspaces = [];
  bool isLoading = true;

  Future<void> getWorkspaces() async {
    try {
      final response = await WorkspaceService.getWorkspaces();

      setState(() {
        workspaces = response.data["workspaces"];
        filteredWorkspaces = workspaces;
        isLoading = false;
      });
    } catch (e) {
      print("Workspace Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchWorkspaces(String query){
    setState(() {
      filteredWorkspaces = workspaces.where((workspace){
        return workspace["name"].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getWorkspaces();
  }


  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        titleSpacing: isSearching ? 16 : null,

        title: !isSearching
            ? const Text(
          "Workspaces",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
            : SizedBox(
          height: 46,
          child: TextField(
            controller: searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: searchWorkspaces,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF161B30),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              hintText: "Search workspaces...",
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),


              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF8A3CFA),
                  width: 1.5,
                ),
              ),


              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF8A3CFA),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        actions: [

          Padding(
            padding: EdgeInsets.only(right: isSearching ? 8.0 : 0.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchController.clear();
                    filteredWorkspaces = workspaces;
                    isSearching = false;
                  } else {
                    isSearching = true;
                  }
                });
              },
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppColors.background,
                title: const Text("Create New Workspace"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Workspace Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final response = await WorkspaceService.createWorkspace(
                          name: nameController.text,
                          description: descriptionController.text,
                        );
                        await getWorkspaces();
                        Navigator.pop(context);
                        nameController.clear();
                        descriptionController.clear();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text("Create"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Workspaces",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Collaborate with your teams",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: filteredWorkspaces.isEmpty
                  ? const Center(
                child: Text(
                  "No workspaces found",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: filteredWorkspaces.length,
                itemBuilder: (context, index) {
                  final workspace = filteredWorkspaces[index]; 

                  return WorkspaceCard(
                    name: workspace["name"] ?? "",
                    description: workspace["description"] ?? "",
                    onTap: () {
                      context.push('/workspacedetail', extra: workspace);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}