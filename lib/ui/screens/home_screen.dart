import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:earthmodel/core/viewmodels/planet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planet AR"),
        backgroundColor: Colors.blue,
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanetProvider>(
      builder: (context, planetProv, _) {

        if (planetProv.context == null) {
          planetProv.initContext(context);
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (planetProv.planetList == null) {
          planetProv.initPlanet();
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              _arcoreView(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    _refreshWidget(),
                    SizedBox(width: 5),
                    _planetList()
                  ],
                ),
              )
            ],
          ),
        );

      },
    );
    
  }

  Widget _refreshWidget() {
    return Consumer<PlanetProvider>(
      builder: (context, planetProv, _) {
        return Container(
          width: 64,
          height: 64,
          child: InkWell(
            onTap: () => planetProv.refreshNode(),
            child: Icon(Icons.refresh, color: Colors.blue),
          ),
        );
      },
    );
  }

  Widget _arcoreView() {
    return Consumer<PlanetProvider>(
      builder: (context, planetProv, _) {
        return ArCoreView(
          onArCoreViewCreated: planetProv.onArCoreViewCreated,
          enableUpdateListener: true,
          enableTapRecognizer: true,
          type: ArCoreViewType.STANDARDVIEW,
        );
      },
    );
  }

  Widget _planetList() {
    return Consumer<PlanetProvider>(
      builder: (context, planetProv, _) {
        return  Expanded(
          child: Container(
            height: 64,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: planetProv.planetList.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Tooltip(
                  message: planetProv.planetList[index]["name"],
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    onTap: () => planetProv.selectPlanet(index),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          
                          _planetItem(planetProv.planetList[index]["asset"]),
                          planetProv.selectedPlanet == index ? Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.6),
                              shape: BoxShape.circle
                            ),
                          ) : SizedBox(),
                        ],
                      )
                      
                    )
                  )
                );
              },
            )
          ),
        );
      },
    );
  }

  Widget _planetItem(String planet) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        image: DecorationImage(
          image: ExactAssetImage(planet),
          fit: BoxFit.cover
        )
      ),
    );
  }
}