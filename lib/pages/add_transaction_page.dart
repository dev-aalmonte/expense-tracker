import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionPage extends StatefulWidget {
  final Function changePage;

  const AddTransactionPage({
    super.key,
    required this.changePage
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  final DateTime _today = DateTime.now();
  late DateTime _actualDate;
  bool _isDeposit = true;

  @override
  void initState() {
    _actualDate = _today;
    _dateController.text = DateFormat('M/d/y').format(_today);
    _amountController.text = "0.00";
    super.initState();
  }

  void _submitForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    final Transaction transaction = Transaction(
      type: _isDeposit ? TransactionType.deposit : TransactionType.spent, 
      amount: double.parse(_amountController.text), 
      date: DateFormat('M/d/y').parse(_dateController.text), 
      description: _descriptionController.text
    );
    
    Provider.of<TransactionsProvider>(context, listen: false).addTransaction(transaction);
    _setDepositPreference(transaction);
    
    widget.changePage();
  }

  void _setDepositPreference(Transaction transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(transaction.type == TransactionType.deposit) {
      await prefs.setDouble('deposit', double.parse(_amountController.text));
    }
    else {
      await prefs.setDouble('spent', double.parse(_amountController.text));
    }
  }

  void _selectDate() async {
    final newDate = await showDatePicker(
      context: context, 
      initialDate: _today, 
      firstDate: _today.subtract(const Duration(days: 30)), 
      lastDate: _today
    );
    _dateController.text = DateFormat('M/d/y').format(newDate ?? _actualDate);
    _actualDate = newDate ?? _actualDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 400,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: AutoSizeTextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false
                ),
                inputFormatters: [
                  CurrencyInputFormatter()
                ],
                fullwidth: true,
                minFontSize: 32,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 62,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.attach_money, size: Theme.of(context).textTheme.displayMedium!.fontSize,),
                  contentPadding: const EdgeInsets.all(20)
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isDeposit = !_isDeposit;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      _isDeposit 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.error 
                    ),
                    foregroundColor: MaterialStatePropertyAll(
                      _isDeposit 
                      ? Theme.of(context).colorScheme.onPrimary 
                      : Theme.of(context).colorScheme.onError
                    ),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16)
                    ),
                    minimumSize: const MaterialStatePropertyAll(Size(118, 42))
                  ),
                  icon: Icon(_isDeposit 
                    ? Icons.arrow_upward
                    : Icons.arrow_downward
                  ),
                  label: Text(_isDeposit ? "Deposit" : "Expense",),
                ),
                const SizedBox(width: 24,),
                Expanded(
                  child: TextField(
                    onTap: (){
                      _selectDate();
                    },
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date'
                    ),
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description'
              ),
              style: const TextStyle(
                fontSize: 18
              ),
            ),
            const SizedBox(height: 24,),
            ElevatedButton(
              onPressed: _submitForm, 
              child: const Text('Add Transaction')
            )
          ],
        ),
      ),
    );
  }
}