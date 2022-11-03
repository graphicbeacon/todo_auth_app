import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/');
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 10,
                  top: 14,
                  bottom: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Go to the store',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_sharp,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '4 Nov 2022',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Lorem ipsum dolor sit amet consectetur',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        GoRouter.of(context).go('/todos/edit');
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
