import 'package:flutter/material.dart';
import 'package:horas_complementarias/screens/Form.dart';
import 'package:horas_complementarias/screens/history.dart';

// Screens
import 'package:horas_complementarias/screens/home.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav>{
  int _p = 0;
  List<Widget> _pantallas = [];

  Widget? _cuerpo;

  @override
  void initState() {
    super.initState();
    _pantallas.add(MyHomePage(title: 'Dashboard',));
    _pantallas.add(HoursForm(title: 'Registrar Actividad', changeScreen: _changeScreen,));
    _pantallas.add(History(title: 'Registro'));
    _cuerpo = _pantallas[_p];
  }

  void _changeScreen(int v){
    _p = v;
    setState(() {
      _cuerpo = _pantallas[_p];
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _cuerpo,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _changeScreen(value);
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: _p,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Inicio',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Agregar',
            icon: Icon(Icons.add_box_outlined)
          ),
          BottomNavigationBarItem(
            label: 'Lista',
            icon: Icon(Icons.list_alt_outlined)
          ),
        ],
      ),
    );
  }
}