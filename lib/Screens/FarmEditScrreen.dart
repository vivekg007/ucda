import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';

class FarmEditScreen extends StatefulWidget {
  String farmerName;
  String farmId;
  String farmName;
  String farmerId;

  FarmEditScreen(this.farmerName, this.farmId, this.farmName, this.farmerId);

  @override
  State<StatefulWidget> createState() {
    return _FarmEditScreen();
  }
}

class _FarmEditScreen extends State<FarmEditScreen> {
  List<UImodel> idProofUIModel = [];
  List<UImodel> GroupListUIModel = [];

  List<DropdownMenuItem> villageList = [];
  List<DropdownMenuItem> groupList = [];
  List<DropdownMenuItem> idproofitems = [];
  List<FarmerMaster> farmermaster = [];
  List<Asset> images = [];
  List<Map> agents = [];
  String? seasoncode;
  String? servicePointId;
  String agentDistributionBal = '';
  List<ProductModel> productlist = [];
  String slctProof = "";
  String val_Proof = "";
  String val_Village = "";
  String slctGroup = "";
  String val_Group = "";
  String Date = '';
  String farmerId = '';
  File? _imageFarm;
  File? _imageFarmer;

  String transferDate = '', labeltransferDate = 'Select Transfer Date';
  String pructransfr = 'Product Transfer';
  String info = 'Information';

  String submt = 'Submit';
  String AresurCancl = 'Are you sure want to cancel?';
  String AresurProcd = 'Are you sure want to proceed?';
  String save = 'Save';
  String farmname = 'Farm Name';
  String farmphoto = 'Farm Photo';

  String procdetils = 'Product Details';
  String Cancel = 'Cancel';
  String yes = 'Yes';
  String no = 'No';
  String gpslocation = 'GPS Location not enabled';
  String variety = 'Variety';
  String ok = 'OK';
  String Cnfm = 'Confirmation';
  String Farmr = 'Farmer';
  String vrty = 'Variety';
  String grade = 'Grade';
  String drivr = 'Driver';
  String processcntrwhse = 'Processing Centre/Warehouse';
  String Slctprocesscntrwhse = 'Select the processing centre/warehouse';
  String trnsdate = 'Transfer Date';
  String trucknum = 'Truck Number';
  String farmerlst = 'Farmer List';
  String NofCrates = 'No. of crates';
  String transCrates = 'Transferred Crates';
  String transwght = 'Transferred Weight (Kgs)';
  String Grosswght = 'Gross Weight(Kgs)';
  String trasnsucc = 'Transaction Successful';
  String proctrnssuccrecpid =
      'Product Transfer Successful.\nYour receipt ID is ';
  String addproduct = 'Please Add Product';
  String Transfrdat = 'Transfer Date should not be empty';
  String proctrwrhuse = 'Processing Centre/Warehouse should not be empty';
  String trucknumemp = 'Truck Number should not be empty';
  String Drivemp = 'Driver  should not be empty';
  String Trsnafrcratemp = 'Transferred Crates should not be empty';
  String Trsnafrcratempty = 'Transferred Crates should not be Zero';
  String Trsnafrcralethcrats =
      'Transferred No. of crates should  be less than No. of crates ';

  String dateSow = 'Date of sowing';
  String cropName = 'Crop Name';
  String farmerName = 'Farmer Name';
  String area = 'Area';
  String totLandhold = 'Total Land Holding (Hectare)';
  String farmeditsuc = 'Farm Edit Submitted Successfully';
  String farmreditsuc = 'Farmer Edit Submitted Successfully';
  String estmd = 'Estimated';
  String yield = 'Yield';
  String maunds = '(maunds)';
  String farmEdit = 'Farm Details';
  String farmerEdit = 'Farmer Edit';
  String infoIdpho = 'ID proof photo should not be empty';
  String farmID = 'Farm ID';
  String update = 'Update';
  String balance = 'Balance';
  String idproofphoto = 'ID Proof Photo';

  var db = DatabaseHelper();

  String Lat = '';
  String Lng = '';

  TextEditingController FarmerNameController = new TextEditingController();

  TextEditingController TotalLandHoldingController =
      new TextEditingController();

  TextEditingController bhigaController = new TextEditingController();
  TextEditingController hectareController = new TextEditingController();

  TextEditingController FarmNameController = new TextEditingController();

  String farmName = "";
  String typTreeShade = "";
  String unProdTree = "";
  String dca = "";
  String avTreeAge = "";
  String prodTree = "";
  String coffeeType = "";
  String spacing = "";
  String tca = "";
  String yeildEstTree = "";
  String treeShade = "";
  String coffeeVariety = "";
  String auditArea = "";
  String farmCode = "";
  String farmerCode = "";

  bool tyTree = false;

  TextEditingController totTrees = new TextEditingController();

  @override
  void initState() {
    super.initState();

    initdata();
    getClientData();
    getLocation();
    setState(() {
      FarmNameController.text = widget.farmName;
      FarmerNameController.text = widget.farmerName;
    });

    print("farmmID:" + widget.farmId);

    bhigaController.addListener(() {
      setState(() {
        double value = double.parse(bhigaController.text.toString()) / 3.987;
        String v = ChangeDecimalTwo(value.toString());
        print("value hect:" + value.toString());
        hectareController.text = v.toString();
      });
    });
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    //agentDistributionBal = agents[0]['agentDistributionBal'];
  }

  void getLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print("latitude :" +
          position.latitude.toString() +
          " longitude: " +
          position.longitude.toString());
      setState(() {
        Lat = position.latitude.toString();
        Lng = position.longitude.toString();
      });
    } else {
      Alert(context: context, title: info, desc: gpslocation, buttons: [
        DialogButton(
          child: Text(
            ok,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: Colors.green,
        )
      ]).show();
    }
  }

  Future<void> initdata() async {
    String farmDetailsqry =
        "select farmIDT,farmName,farmerId,prodLand,landProd,currentConversion,pltStatus,totLand,insType,inspName,insDate,inspDetList,dynfield,geoStatus,chemicalAppLastDate,totTrees from farm where farmIDT =\'" +
            widget.farmId +
            "\'";
    List farmDetails = await db.RawQuery(farmDetailsqry);
    print('farmDetails ' + farmDetails.toString());

    for (int i = 0; i < farmDetails.length; i++) {
      String typShTree = farmDetails[i]['currentConversion'].toString();
      //valShadeTree = typShTree;
      print("typsshade:" + typShTree);
      List typShList = [];
      List typQShList = [];
      print("shade tree:" + typShTree.toString());

      List<String> typShL = typShTree.split(',').toList();

      print('typShadeTree:' + typShL.toString());

      for (int k = 0; k < typShL.length; k++) {
        String t = typShL[k].toString();
        typQShList.add("'$t'");
        typShList.add(t);
      }
      String cCodeV = typQShList.join(',');
      print("cCode:" + cCodeV);
      List cNameList1 = await db.RawQuery(
          'select  property_value from animalCatalog where DISP_SEQ IN ($cCodeV)');
      List cCodeList = [];
      List cCodeQList = [];
      for (int j = 0; j < cNameList1.length; j++) {
        String cCodeValue = cNameList1[j]['property_value'].toString();
        cCodeList.add(cCodeValue);
      }
      String propertyName = cCodeList.join(',');
      print("cNameList:" + cNameList1.toString() + propertyName);
      typTreeShade = propertyName;
      //typTreeShade = propertyName;

      List coffTypList = await db.RawQuery(
          'select vName from varietyList v,farm f where v.vCode = f.insType');
      List coffVarList = await db.RawQuery(
          'select grade from procurementGrade p,farm f where p.gradeCode = f.inspName');

      /*varities changes*/

      String vars = farmDetails[i]['inspName'].toString().replaceAll(' ', '');
      List typvList = [];
      List typQvList = [];
      print("varieties:" + vars.toString());

      List<String> typvL = vars.split(',').toList();
      print('typShadeTree:' + typvL.toString());

      for (int k = 0; k < typvL.length; k++) {
        String t = typvL[k].toString();
        typQvList.add("'$t'");
        typvList.add(t);
      }
      String vCodeV = typQvList.join(',');
      print("cCode:" + vCodeV);
      List vNameList1 = await db.RawQuery(
          'select distinct grade from procurementGrade where gradeCode IN ($vCodeV)');
      List vCodeList = [];
      List vCodeQList = [];
      for (int j = 0; j < vNameList1.length; j++) {
        String vCodeValue = vNameList1[j]['grade'].toString();
        vCodeList.add(vCodeValue);
      }
      String vName = vCodeList.join(',');
      print("cNameList:" + vNameList1.toString());
      coffeeVariety = vName;

      /*varities changes end*/

      /*shade tree*/
      /*   String sTree = farmDetails[i]['currentConversion'].toString();

      if(sTree.isNotEmpty){
        List sTreeList = await db.RawQuery(
            'select property_value from animalCatalog where DISP_SEQ = \'' +sTree+ '\'');
        print("shadetreelist:"+sTreeList.length.toString());
        typTreeShade = sTreeList[0]['property_value'].toString()??"";
      }*/

      setState(() {
        spacing = farmDetails[i]['totLand'].toString();
        tca = farmDetails[i]['prodLand'].toString();
        dca = farmDetails[i]['pltStatus'].toString();
        avTreeAge = farmDetails[i]['geoStatus'].toString();
        treeShade = farmDetails[i]['dynfield'].toString();
        unProdTree = farmDetails[i]['chemicalAppLastDate'].toString();
        prodTree = farmDetails[i]['insDate'].toString();
        yeildEstTree = farmDetails[i]['inspDetList'].toString();
        coffeeType = coffTypList[0]['vName'].toString();
        //coffeeVariety = coffVarList[0]['grade'].toString();
        auditArea = farmDetails[i]['landProd'].toString() ?? "";
        totTrees.text = farmDetails[i]['totTrees'].toString() ?? "";
        if (int.parse(treeShade) >= 1) {
          tyTree = true;
        } else {
          tyTree = false;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void translate() async {
    try {
      String? Lang = '';
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Lang = prefs.getString("langCode");
      } catch (e) {
        Lang = 'en';
      }
      String qry =
          'select * from labelNamechange where tenantID =  \'cediam\' and lang = \'' +
              Lang! +
              '\'';

      print('Lanquery' + qry);
      List transList = await db.RawQuery(qry);
      print('translist:' + transList.toString());
      for (int i = 0; i < transList.length; i++) {
        String classname = transList[i]['className'];
        String labelName = transList[i]['labelName'];
        switch (classname) {
          case "prductrnsuc":
            setState(() {
              proctrnssuccrecpid = labelName;
            });
            break;
          case "transactionsuccesfull":
            setState(() {
              trasnsucc = labelName;
            });
            break;
          case "yes":
            setState(() {
              yes = labelName;
            });
            break;
          case "no":
            setState(() {
              no = labelName;
            });
            break;
          case "gpslocation":
            setState(() {
              gpslocation = labelName;
            });
            break;
          case "variety":
            setState(() {
              variety = labelName;
            });
            break;

          case "Cancel":
            setState(() {
              Cancel = labelName;
            });
            break;
          case "rusurecancel":
            setState(() {
              AresurCancl = labelName;
            });
            break;
          case "confirm":
            setState(() {
              Cnfm = labelName;
            });
            break;
          case "ArewntPrcd":
            setState(() {
              AresurProcd = labelName;
            });
            break;
          case "save":
            setState(() {
              save = labelName;
            });
            break;
          case "farmname ":
            setState(() {
              farmname = labelName;
            });
            break;
          case "farmphoto":
            setState(() {
              farmphoto = labelName;
            });
            break;
          case "procdetils":
            setState(() {
              procdetils = labelName;
            });
            break;
          case "info":
            setState(() {
              info = labelName;
            });
            break;
          case "farmer":
            setState(() {
              Farmr = labelName;
            });
            break;
          case "Variety":
            setState(() {
              vrty = labelName;
            });
            break;
          case "Grade":
            setState(() {
              grade = labelName;
            });
            break;
          case "submit":
            setState(() {
              submt = labelName;
            });
            break;
          case "producttransfer":
            setState(() {
              pructransfr = labelName;
            });
            break;
          case "transferdat":
            setState(() {
              trnsdate = labelName;
            });
            break;
          case "Slcttransferdat":
            setState(() {
              labeltransferDate = labelName;
            });
            break;
          case "trunum":
            setState(() {
              trucknum = labelName;
            });
            break;
          case "driv":
            setState(() {
              drivr = labelName;
            });
            break;
          case "procentrwarehse":
            setState(() {
              processcntrwhse = labelName;
            });
            break;
          case "Slctprcwrhuse":
            setState(() {
              Slctprocesscntrwhse = labelName;
            });
            break;
          case "farmerlist":
            setState(() {
              farmerlst = labelName;
            });
            break;
          case "NoCrates":
            setState(() {
              NofCrates = labelName;
            });
            break;
          case "grosswght":
            setState(() {
              Grosswght = labelName;
            });
            break;
          case "trsncrates":
            setState(() {
              transCrates = labelName;
            });
            break;
          case "trswght":
            setState(() {
              transwght = labelName;
            });
            break;
          case "addprct":
            setState(() {
              addproduct = labelName;
            });
            break;
          case "trsfrdate":
            setState(() {
              Transfrdat = labelName;
            });
            break;
          case "prcenwremp":
            setState(() {
              proctrwrhuse = labelName;
            });
            break;
          case "truckemp":
            setState(() {
              trucknumemp = labelName;
            });
            break;
          case "drivremp":
            setState(() {
              Drivemp = labelName;
            });
            break;
          case "trafrcrtasemp":
            setState(() {
              Trsnafrcratemp = labelName;
            });
            break;
          case "Trsfrcratesempty":
            setState(() {
              Trsnafrcratempty = labelName;
            });
            break;
          case "Trsfrlethcrats":
            setState(() {
              Trsnafrcralethcrats = labelName;
            });
            break;
          case "ok":
            setState(() {
              ok = labelName;
            });
            break;
          case "dateSow":
            setState(() {
              dateSow = labelName;
            });
            break;
          case "cropName":
            setState(() {
              cropName = labelName;
            });
            break;
          case "farmerName":
            setState(() {
              farmerName = labelName;
            });
            break;
          case "area":
            setState(() {
              area = labelName;
            });
            break;
          case "totLandhold":
            setState(() {
              totLandhold = labelName;
            });
            break;
          case "farmeditsuc":
            setState(() {
              farmeditsuc = labelName;
            });
            break;
          case "farmreditsuc":
            setState(() {
              farmreditsuc = labelName;
            });
            break;
          case "estmd":
            setState(() {
              estmd = labelName;
            });
            break;
          case "yield":
            setState(() {
              yield = labelName;
            });
            break;
          case "maunds":
            setState(() {
              maunds = labelName;
            });
            break;
          case "farmEdit":
            setState(() {
              farmEdit = labelName;
            });
            break;
          case "farmerEdit":
            setState(() {
              farmerEdit = labelName;
            });
            break;
          case "infoIdpho":
            setState(() {
              infoIdpho = labelName;
            });
            break;
          case "farmId":
            setState(() {
              farmID = labelName;
            });
            break;
          case "update":
            setState(() {
              update = labelName;
            });
            break;
          case "balance":
            setState(() {
              balance = labelName;
            });
            break;
          case "idproofphoto":
            setState(() {
              idproofphoto = labelName;
            });
            break;
        }
      }
    } catch (e) {
      print('translation err' + e.toString());
      //toast(e.toString());
    }
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: Cancel,
          desc: AresurCancl,
          buttons: [
            DialogButton(
              child: Text(
                yes,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            ),
            DialogButton(
              child: Text(
                no,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              farmEdit,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Container(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: FarmEditUI(
                  context), // <<<<< Note this change for the return type
            ),
          ),
        ),
      ),
    );
  }

  Widget DatatableProductDetails() {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    columns.add(DataColumn(label: Text(cropName)));
    columns.add(DataColumn(label: Text(variety)));
    columns.add(DataColumn(label: Text(estmd + ' \n' + yield + '\n' + maunds)));
    columns.add(DataColumn(label: Text(dateSow)));

    for (int i = 0; i < productlist.length; i++) {
      List<DataCell> singlecell = [];
      //1
      singlecell.add(DataCell(Text(productlist[i].cropName)));
      singlecell.add(DataCell(Text(productlist[i].Variety)));
      singlecell.add(DataCell(Text(productlist[i].EstimatedYield)));
      singlecell.add(DataCell(Text(productlist[i].DateOfSowing)));

      rows.add(DataRow(
        cells: singlecell,
      ));
    }

    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Image for production",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      print("kirubhasankar" + images[0].toString());
      // String  imageB64 = base64Encode(images[i].getByteData());
    });
  }

  List<Widget> FarmEditUI(BuildContext context) {
    List<Widget> listings = [];

    listings.add(txt_label_icon(
        farmerName, Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(FarmerNameController.text));
    listings.add(txt_label_icon(
        "Farm Name", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(FarmNameController.text));
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon("Coffee Type", Colors.black, 14.0, true,
                    Icons.location_on)),
            Expanded(
                child: txt_label_icon("Coffee Variety", Colors.black, 14.0,
                    true, Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(coffeeType)),
            Expanded(child: cardlable_dynamic(coffeeVariety)),
          ],
        ),
      ),
    );
    /*listings.add(txt_label_icon(
        "Coffee Type", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(coffeeType));
    listings.add(txt_label_icon(
        "Coffee Variety", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(coffeeVariety));*/

    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon("Spacing of Coffee \n  Trees (Feet)",
                    Colors.black, 14.0, true, Icons.location_on)),
            Expanded(
                child: txt_label_icon("Total Coffee Acreage", Colors.black,
                    14.0, true, Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(spacing)),
            Expanded(child: cardlable_dynamic(tca)),
          ],
        ),
      ),
    );
    /*listings.add(txt_label_icon(
        "Spacing of Coffee Trees", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(spacing));
    listings.add(txt_label_icon(
        "Total Coffee Acreage", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(tca));*/
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon("Declared Coffee Area", Colors.black,
                    14.0, true, Icons.location_on)),
            Expanded(
                child: txt_label_icon("Audited Area", Colors.black, 14.0, true,
                    Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(dca)),
            Expanded(child: cardlable_dynamic(auditArea)),
          ],
        ),
      ),
    );
    /* listings.add(txt_label_icon(
        "Declared Coffee Area", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(dca));
    listings.add(txt_label_icon(
        "Audited Area", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(auditArea));*/
    listings.add(txt_label_icon("Average Age of Coffee Trees (in years)",
        Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(avTreeAge));
    listings.add(txt_label_icon(
        "Number of Shade Trees", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(treeShade));
    if (tyTree) {
      listings.add(txt_label_icon(
          "Type of Shade Tree", Colors.black, 14.0, true, Icons.account_box));
      listings.add(cardlable_dynamic(typTreeShade));
    }

    listings.add(txt_label_icon(
        "Total Number of Trees", Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(totTrees.text));
    listings.add(txt_label_icon("Number of Unproductive  Trees", Colors.black,
        14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(unProdTree));

    listings.add(txt_label_icon("Number of Productive Trees", Colors.black,
        14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(prodTree));

    listings.add(txt_label_icon("Yield Estimate/Red cherry (Kgs)", Colors.black,
        14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(yeildEstTree));

    if (productlist != '' && productlist.length > 0) {
      listings.add(txt_label(procdetils, Colors.black, 14.0, false));
      listings.add(DatatableProductDetails());
    }

    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );

    return listings;
  }

  Future getImage() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imageFarm = File(image!.path);
    });
  }

  Future getImageFarmer() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imageFarmer = File(image!.path);
    });
  }

  saveFarmerEditData() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    String revNo = recNo.toString();

    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0, \'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\', \'' +
            agentid! +
            '\',\' ' +
            agentToken! +
            '\',\' ' +
            msgNo +
            '\',\' ' +
            servicePointId! +
            '\',\' ' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.farmer_edit, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());

    String date = Date;
    String season = seasoncode!;
    String village = val_Village;
    String learnGroup = val_Group;
    String farmId = widget.farmId;
    String longitude = Lng;
    String latitude = Lat;
    String isSynched = '1';
    String farmphoto = "";
    /* if (_imageFarm != '') {
      List<int> imageBytes = _imageFarm!.readAsBytesSync();
      farmphoto = base64Encode(imageBytes);
    }*/
    String farmerPhotoPath = "";
    if (_imageFarmer != null) {
      farmerPhotoPath = _imageFarmer!.path;
    }
    //  String idPhotoPath = "";
    if (_imageFarm != null) {
      farmphoto = _imageFarm!.path;
    }
    String farmerphoto = "";
    String farmerMobile = "";
    String IdProofphoto = "";
    String farmProduction = "";
    String fingerPrint = "";
    String idProof = val_Proof;
    String idProofOthr = "";
    String idstatus = "";
    String frPhoto = "";
    String farmTotalProd = FarmNameController.text;
    String pltStatus = "";
    String geoStatus = "";
    String trader = "";
    String idProofVal = "";
    int SaveSensitizing = await db.SaveEditFarmer(
        isSynched,
        revNo,
        widget.farmerId,
        Lat,
        Lng,
        msgNo,
        farmerPhotoPath,
        farmerMobile,
        Lat,
        Lng,
        msgNo,
        farmphoto,
        farmId,
        season,
        farmProduction,
        fingerPrint,
        idProof,
        idProofOthr,
        idProofVal,
        Lat,
        Lng,
        msgNo,
        IdProofphoto,
        idstatus,
        frPhoto,
        farmTotalProd,
        pltStatus,
        geoStatus,
        trader);

    print(SaveSensitizing);

    toast(farmeditsuc);

    int issync = await db.UpdateTableValue(
        'edit_farmer', 'isSynched', '0', 'recId', revNo);
    print(issync);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  void ondelete() {
    if (_imageFarm != null) {
      setState(() {
        _imageFarm = null;
      });
    }
  }

  void ondeleteFarmer() {
    if (_imageFarmer != null) {
      setState(() {
        _imageFarmer = null;
      });
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }
}

class ProductModel {
  String cropName;
  String Variety;
  String EstimatedYield;
  String DateOfSowing;

  ProductModel(
      this.cropName, this.Variety, this.EstimatedYield, this.DateOfSowing);
}
