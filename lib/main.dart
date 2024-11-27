import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RecipeListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Recipe {
  String name;
  String description;
  String preparation;
  String imagePath;
  String sideDish; // "Con papa" o "Con camote"
  String dishType; // Tipo de plato

  Recipe({
    required this.name,
    required this.description,
    required this.preparation,
    required this.imagePath,
    this.sideDish = "Con papa",
    this.dishType = "Principal",
  });
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [
    Recipe(
      name: "Lomito",
      description: "Un clásico plato Peruviano",
      preparation: "1. Corta el lomo en tiras...\n2. Sofríe con verduras.",
      imagePath: "assets/images/lomo_saltado.jpg",
    ),
    Recipe(
      name: "Ají de Gallina",
      description: "Un plato cremoso y delicioso",
      preparation: "1. Cocina la gallina...\n2. Prepara la crema de ají.",
      imagePath: "assets/images/aji_de_gallina.jpg",
    ),
  ];

  void updateRecipe(int index, Recipe updatedRecipe) {
    setState(() {
      recipes[index] = updatedRecipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recetas")),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              recipes[index].imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(recipes[index].name),
            subtitle: Text(recipes[index].description),
            onTap: () async {
              final updatedRecipe = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    recipe: recipes[index],
                  ),
                ),
              );

              if (updatedRecipe != null) {
                updateRecipe(index, updatedRecipe);
              }
            },
          );
        },
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController preparationController;
  String sideDish = "Con papa";
  String dishType = "Principal";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.recipe.name);
    descriptionController =
        TextEditingController(text: widget.recipe.description);
    preparationController =
        TextEditingController(text: widget.recipe.preparation);
    sideDish = widget.recipe.sideDish;
    dishType = widget.recipe.dishType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Receta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del plato
            Center(
              child: Image.asset(
                widget.recipe.imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Nombre de la receta
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            SizedBox(height: 16),
            // Descripción de la receta
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Descripción"),
            ),
            SizedBox(height: 16),
            // Preparación
            TextField(
              controller: preparationController,
              decoration: InputDecoration(labelText: "Preparación"),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            // Radio Buttons: Con papa o con camote
            Text("Acompañamiento"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Con papa"),
                    value: "Con papa",
                    groupValue: sideDish,
                    onChanged: (value) {
                      setState(() {
                        sideDish = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Con camote"),
                    value: "Con camote",
                    groupValue: sideDish,
                    onChanged: (value) {
                      setState(() {
                        sideDish = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Dropdown: Tipo de plato
            Text("Tipo de plato"),
            DropdownButtonFormField<String>(
              value: dishType,
              items: ["Principal", "Entrada", "Postre"]
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  dishType = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            Spacer(),
            // Botón Guardar
            ElevatedButton(
              onPressed: () {
                // Crear la receta actualizada
                final updatedRecipe = Recipe(
                  name: nameController.text,
                  description: descriptionController.text,
                  preparation: preparationController.text,
                  imagePath: widget.recipe.imagePath,
                  sideDish: sideDish,
                  dishType: dishType,
                );

                // Regresar los datos a la pantalla anterior
                Navigator.pop(context, updatedRecipe);
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
