import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGameScreen(),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  final int rows = 20;
  final int columns = 20;
  final List<int> snake = [45, 44, 43];
  int food = Random().nextInt(400);
  bool isPlaying = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      if (isPlaying) {
        updateSnake();
        if (checkCollision()) {
          timer.cancel();
          // Handle game over
          // You can show a dialog or navigate to a new screen
        }
        if (snake[0] == food) {
          // Snake ate the food
          // Generate new food location
          food = Random().nextInt(rows * columns);
          // Add new segment to the snake
          snake.add(snake.last);
          // Increment the score
          score++;
        }
        setState(() {});
      }
    });
  }

  void updateSnake() {
    setState(() {
      for (int i = snake.length - 1; i > 0; i--) {
        snake[i] = snake[i - 1];
      }
      switch (direction) {
        case Direction.up:
          snake[0] -= columns;
          break;
        case Direction.down:
          snake[0] += columns;
          break;
        case Direction.left:
          snake[0] -= 1;
          break;
        case Direction.right:
          snake[0] += 1;
          break;
      }
    });
  }

  bool checkCollision() {
    if (snake[0] < 0 ||
        snake[0] >= rows * columns ||
        (snake[0] % columns == 0 && direction == Direction.left) ||
        (snake[0] % columns == columns - 1 && direction == Direction.right) ||
        snake.sublist(1).contains(snake[0])) {
      return true; // Collision detected
    }
    return false; // No collision
  }

  void resetGame() {
    setState(() {
      // Reset snake, food, direction, and isPlaying
      snake.clear();
      snake.addAll([45, 44, 43]);
      food = Random().nextInt(rows * columns);
      direction = Direction.right;
      isPlaying = true;
      // Reset the score
      score = 0;
    });
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        backgroundColor: const Color(0xff750000),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 0 && direction != Direction.up) {
            // Swiped down
            direction = Direction.down;
          } else if (details.primaryDelta! < 0 && direction != Direction.down) {
            // Swiped up
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0 && direction != Direction.left) {
            // Swiped right
            direction = Direction.right;
          } else if (details.primaryDelta! < 0 && direction != Direction.right) {
            // Swiped left
            direction = Direction.left;
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://i.pinimg.com/originals/77/59/a3/7759a3f6d6bc621cb496f306f9358766.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                color: Color(0xFF8abb7e),
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "This snake game is developed by Abhishek, enjoy the game :)",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Display the score
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                    ),
                    itemCount: rows * columns,
                    itemBuilder: (BuildContext context, int index) {
                      if (snake.contains(index)) {
                        return SnakeSegment();
                      } else if (index == food) {
                        return Food();
                      } else {
                        return EmptyGrid();
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPlaying = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      primary: Colors.green,
                    ),
                    child: const Text('Play'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPlaying = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      primary: Colors.yellow,
                    ),
                    child: const Text('Pause'),
                  ),
                  ElevatedButton(
                    onPressed: resetGame,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      primary: Colors.red,
                    ),
                    child: const Text('Restart'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (direction != Direction.down) {
                        direction = Direction.up;
                      }
                    },
                    icon: Icon(Icons.arrow_upward),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (direction != Direction.left) {
                        direction = Direction.left;
                      }
                    },
                    icon: Icon(Icons.arrow_back),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      if (direction != Direction.right) {
                        direction = Direction.right;
                      }
                    },
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (direction != Direction.up) {
                        direction = Direction.down;
                      }
                    },
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Direction { up, down, left, right }

Direction direction = Direction.right;

class SnakeSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Food extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}

class EmptyGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}
