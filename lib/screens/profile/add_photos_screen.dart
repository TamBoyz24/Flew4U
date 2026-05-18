import 'package:flutter/material.dart';

class AddPhotosScreen extends StatefulWidget {
  const AddPhotosScreen({super.key});

  @override
  State<AddPhotosScreen> createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends State<AddPhotosScreen> {
  // Mock selection state
  Set<int> selectedIndices = {2, 4}; // Just for visual mockup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add Photos", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("DONE", style: TextStyle(color: Colors.tealAccent.shade400, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: 15,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.tealAccent.shade400, width: 1.5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.tealAccent.shade400, size: 28),
                  const SizedBox(height: 5),
                  Text("Take Photo", style: TextStyle(color: Colors.tealAccent.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }
          
          bool isSelected = selectedIndices.contains(i);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedIndices.remove(i);
                } else {
                  selectedIndices.add(i);
                }
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://picsum.photos/200?random=$i",
                  fit: BoxFit.cover,
                ),
                
                // Selection overlay
                if (isSelected)
                  Container(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),

                // Checkbox simulation
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.tealAccent.shade400 : Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: isSelected 
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
