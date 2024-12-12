import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key); // Añade el parámetro 'key'

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Lista de datos para el onboarding
  final List<Map<String, String>> _onboardingData = [ //MAP-lista donde cada elemento tiene 2 partes. clave-valor
    {
      "title": "Bienvenido",
      "description": "Controla tus gastos de manera fácil y eficiente.",
      "image": "lib/assets/onboarding1.png",
    },
    {
      "title": "Organiza tus gastos",
      "description": "Categoriza tus gastos y visualiza tus ahorros.",
      "image": "lib/assets/onboarding2.png",
    },
    {
      "title": "Cumple tus metas",
      "description": "Ahorra para cumplir tus objetivos financieros.",
      "image": "lib/assets/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( //estruvtura
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController, //controladpr->maneja y monitorea datos -widget con formularios, listas, etc
              itemCount: _onboardingData.length, //itemCount->cuantos elemento o cosas debe de mostrar una lista 
              onPageChanged: (index) {
                setState(() { //indica que algo en el estado del widget ha cambiado y va contruir el widget on el nuevo estado
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      data["image"]!,
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data["title"]!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        data["description"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: _currentPage == index ? 12 : 8, // Cambia el ancho del indicador según si corresponde a la página activa (`_currentPage`).
                height: 8, //altura fija para todos los indicadores
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton( // Crea un botón elevado con un diseño predeterminado.
            onPressed: () { //la acción que se realiza al presionar el botón 
              if (_currentPage == _onboardingData.length - 1) {
                Navigator.pushReplacementNamed(context, '/login'); //cambia a la siguiente pantalla pero la pantalla anterior cambia *No vuelve atras*
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut, //curva de animación para que la transición sea suave
                );
              }
            },
            child: Text(
              _currentPage == _onboardingData.length - 1
                  ? "Comenzar"
                  : "Siguiente",
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
