import 'package:flutter/cupertino.dart';
import 'dart:io';
import './widgets/chart.dart';
import './widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, 
  //   DeviceOrientation.portraitDown]
  //   );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expences',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple).copyWith(
            secondary: Colors.green),
            errorColor: Colors.red
            // fontFamily: 'Quicksand',
      ),
      home: const MyHomePage(),
    ) ;
  }
}
class MyHomePage extends StatefulWidget{
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late String titleInput;



    final List<Transaction> _userTransactions = [
    //  Transaction(
    //   id: 't1', 
    //   title: 'New Shoes', 
    //   amount: 69.99, 
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2', 
    //   title: 'New Shoes', 
    //   amount: 79.99, 
    //   date: DateTime.now(),
    // ),
  ];

   bool _showChart = false;

   List <Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
         const Duration(days: 7),
      ),);
    }).toList();


  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
      id: DateTime.now().toString(), 
      title: txTitle, 
      amount: txAmount, 
      date: chosenDate,
      
      );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
      return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: NewTransaction(_addNewTransaction),);
    },);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape ;
    final appBar =AppBar(
        title: const Text('Expences'),
        actions: <Widget>[
          IconButton(onPressed: () =>_startAddNewTransaction(context),
           icon: const Icon(Icons.add))
        ],
      );

      final txListWidget = Container(
                height: (
              mediaQuery.size.height - 
              appBar.preferredSize.height - 
              mediaQuery.padding.top) * 0.7,
             child: TransactionList(
              _userTransactions, 
              deleteTx: _deleteTransaction 
              ),);
      final pageBody = SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Show Chart'),

              Switch(
                 value: _showChart, 
                 onChanged: (val) {

                  setState(() {
                    _showChart = val;
                });
              },),
             ],
            ),
            if(!isLandscape) Container(
                  height: (mediaQuery.size.height -
                         appBar.preferredSize.height - mediaQuery.padding.top)* 0.3,
                      child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart 
               ? Container(
                  height: (mediaQuery.size.height -
                         appBar.preferredSize.height - mediaQuery.padding.top)* 0.7,
                      child: Chart(_recentTransactions),
              ): txListWidget
            ],
          ),
      );   
    return Platform.isIOS ? CupertinoPageScaffold(child: appBar,) : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>_startAddNewTransaction(context),
        ),
    );
  }
} 