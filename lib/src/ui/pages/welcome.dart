import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';

class const Welcome({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: .min,
        children: [
          Center(
            child: Text(
              key: Key("welcome"),
              "welcome",
              style: .new(fontSize: 36.0),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("test").snapshots(),
              builder: (context, snapshot) {
                late List<Widget> children;

                if (snapshot.hasError) {
                  children = [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16.0),
                    Text('Stack trace: ${snapshot.stackTrace}'),
                  ];
                } else {
                  switch (snapshot.connectionState) {
                    case .none:
                      children = [
                        const Icon(Icons.info, color: Colors.blue, size: 64.0),
                        const SizedBox(height: 16.0),
                        const Text('SUCCESS'),
                      ];
                      break;
                    case .waiting:
                      children = [
                        const SizedBox(
                          width: 64.0,
                          height: 64.0,
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 16.0),
                        const Text('Awaiting'),
                      ];
                      break;
                    case .active:
                      children = [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 64.0,
                        ),
                        const SizedBox(height: 16.0),
                        Text('\$${snapshot.data!.docs[0]["message"]}'),
                      ];
                      break;
                    case .done:
                      children = [
                        const Icon(Icons.info, color: Colors.blue, size: 64.0),
                        const SizedBox(height: 16.0),
                        Text('\$${snapshot.data} (Closed)'),
                      ];
                      break;
                  }
                }

                return Column(mainAxisAlignment: .center, children: children);
              },
            ),
          ),
        ],
      ),
    );
  }
}
