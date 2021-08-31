import 'package:EarnShow/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Withdrawal extends StatefulWidget {
  @override
  _WithdrawalState createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  var _balance;
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<WalletProvider>(context, listen: false).fetchBalance();
      setState(() {
        _balance = Provider.of<WalletProvider>(context, listen: false).balance;
      });
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white10,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Withdrawal',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: Theme.of(context).secondaryHeaderColor),
        ),
        leading: new ClipOval(
          child: SizedBox(
            height: 50,
            width: 50,
            child: Material(
              child: InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColorDark,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: FlatButton(
        onPressed: () {},
        child: Text(
          "Withdrawal",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Montserrat'),
        ),
        color: Theme.of(context).primaryColorDark,
        minWidth: DEVICE_SIZE.width,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Card(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Wallet Balance ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: DEVICE_SIZE.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: DEVICE_SIZE.width * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            Consumer<WalletProvider>(
                              builder: (context, wallet, _) => Text(
                                wallet.balance != null
                                    ? wallet.balance.toString()
                                    : "0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: DEVICE_SIZE.width * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "GST 20% ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: DEVICE_SIZE.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "- ₹ ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: DEVICE_SIZE.width * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            Consumer<WalletProvider>(
                              builder: (context, wallet, _) => Text(
                                wallet.balance != null
                                    ? (wallet.balance * .2).toString()
                                    : "0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: DEVICE_SIZE.width * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Total Amount ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: DEVICE_SIZE.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: DEVICE_SIZE.width * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            Consumer<WalletProvider>(
                              builder: (context, wallet, _) => Text(
                                wallet.balance != null
                                    ? (wallet.balance - (wallet.balance * .2))
                                        .toString()
                                    : "0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: DEVICE_SIZE.width * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ExpansionTile(
              title: Text('Paytm'),
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      hintText: "Phone Number",
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('PayPal'),
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      hintText: "PayPal Id",
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Bank Account'),
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        color: Colors.blue,
                      ),
                      hintText: "Account No",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        color: Colors.blue,
                      ),
                      hintText: "Confirm Account No",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.code,
                        color: Colors.blue,
                      ),
                      hintText: "IFSC Code",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.blue,
                      ),
                      hintText: "Name",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Note : Amount will be transfer only for valid transaction (Valid Email Id / Valid Codes). Minimum 5 - 6 working is needed to transfer the money.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
