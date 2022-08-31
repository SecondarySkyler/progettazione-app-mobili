import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_closet/models/Outfit.dart';
import 'package:my_closet/widgets/ListaImmaginiVestiti.dart';
import '../screens/FormOutfit.dart';
import '../screens/OutfitDetail.dart';
import '/main.dart';
import '/models/Indumento.dart';
import '/screens/FormIndumento.dart';
import '/screens/ListaVestiti.dart';
import '/screens/VestitoDetail.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (args != null && args is int) {
          return MaterialPageRoute(builder: (_) => App(index: args));
        }
        return MaterialPageRoute(builder: (_) => App());
      case '/lista':
        return MaterialPageRoute(builder: (_) => ListaVestiti());
      case '/form':
        if (args != null && args is Indumento) {
          return MaterialPageRoute(builder: (_) => FormIndumento(vestito: args));
        } else if(args != null && args is XFile) {
          return MaterialPageRoute(builder: (_) => FormIndumento(img: args));
        } else if (args == null) {
          return MaterialPageRoute(builder: (_) => const FormIndumento());
        }
        return _errorRoute();
      case '/detail':
        if (args != null && args is int) {
          return MaterialPageRoute(builder: (_) => VestitoDetail(vestitoId: args));
        }
        return _errorRoute();
      case '/formOutfit':
        if (args != null && args is Outfit) {
          return MaterialPageRoute(builder: (_) => FormOutfit(outfitToUpdate: args));
        }
        //route quando creo outfit nuovo
        return MaterialPageRoute(builder: (_) => FormOutfit());
      case '/outfitDetail':
        if (args != null && args is int) {
          return MaterialPageRoute(builder: (_) => OutfitDetail(outfitId: args));
        }
        return _errorRoute();


      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
        ),
        body: const Center(
          child: Text('NO ROUTE FOUND :('),
        ),
      );
    });
  }
}