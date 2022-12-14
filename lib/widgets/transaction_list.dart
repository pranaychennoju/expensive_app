import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, {Key? key, required this.deleteTx}) : super(key: key);
 @override
  Widget build(BuildContext context) {
    return  transactions.isEmpty ? 
    LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        const Text('No transactions added yet!'),
        const SizedBox( 
          height: 20,
        ),
        SizedBox(
          height: constraints.maxHeight *0.6,  
          child: Image.asset(
            'assets/images/smile.png',
           fit: BoxFit.cover,)),
      ],);
    }) : ListView.builder(
             itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8, 
                  horizontal: 5),
                child: ListTile(leading: CircleAvatar(radius: 30, 
                child: Padding(
              
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('\$${transactions[index].amount}'),
                    ),
                ),
                ),
                title: Text(
                  transactions[index].title, 
                  style: Theme.of(context).textTheme.titleLarge
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 460  ? TextButton.icon(
                      onPressed: () => deleteTx(transactions[index].id), 
                      icon: Icon(Icons.delete), 
                      label: Text('Delete'), 
                     // textColor: Theme.of(context).errorColor,
                      ): 
                     IconButton(icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTx(transactions[index].id),
                      ),
                ),
              );
             },
             itemCount: transactions.length,
             
             
      
    );
    
  }
}