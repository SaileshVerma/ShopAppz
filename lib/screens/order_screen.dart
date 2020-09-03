import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../Providers/orders.dart' show Orders;
import '../widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isloading = false;
  // @override
  // void initState() {
  //   setState(() {
  //     _isloading = true;
  //   });
  //   Future.delayed(Duration.zero).then((_) async {
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isloading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(), //ADDING FUTURE BUILDER
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //LOGIC FOR ERROR HANDLONG
              return Center(
                child: Text("AN ERROR OCCUR"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderdata, child) => ListView.builder(
                  itemCount: orderdata.order.length,
                  itemBuilder: (ctx, i) => OrderItem(orderdata.order[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
