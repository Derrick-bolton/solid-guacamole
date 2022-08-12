import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum3/Services/Searchmethods.dart';

class Msearch extends StatefulWidget {
  const Msearch({Key? key}) : super(key: key);

  @override
  State<Msearch> createState() => _MsearchState();
}

class _MsearchState extends State<Msearch> {
  TextEditingController _search=TextEditingController();
  bool isShowuser=false;
  var queryResultset=[];
  var tempSearchstore=[];


  initiateusersearch(value)async{
    if(value.length==0){
      setState(() {
        queryResultset=[];
        tempSearchstore=[];
      });
    }
    var capvalue=value.substring(0,1).toUpperCase()+value.substring(1);
    if(queryResultset.length==0 && value.length==1 ){
      SearchService().SearchUser(value).then((QuerySnapshot<Map<String,dynamic>> snapshot){
        for(int i=0;i<snapshot.docs.length;++i){
          queryResultset.add(snapshot.docs[i].data());
        }
      });
    }else{
      tempSearchstore=[];
      queryResultset.forEach((element) {
        if(element['username'].startsWith(capvalue)){
          setState(() {
            tempSearchstore.add(element);
          });
        }
      });
    }
  }


  Widget usercard(data){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(data['profilepic']),
            ),
            Text(data['username'])
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: TextFormField(
          controller: _search,
          onChanged: (value){
            initiateusersearch(value);
          },
          onFieldSubmitted: (value){
            setState(() {
              isShowuser=true;
            });
          },
          decoration: InputDecoration(
            labelText: "Search user",
          ),
        ),
      ),

      body: isShowuser? ListView(
        children:tempSearchstore.map((element){
          return usercard(element);
        }).toList()
        ,
      )
/*
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").where("searchkey",isEqualTo: _search.text.substring(0,1).toUpperCase()).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(!snapshot.hasData){
              return Center(
                child: Text("No match found",
                  style: TextStyle(
                    color: Colors.black,
                  ),),
              );
            }

            initiateusersearch(_search.text,);
            return ListView.builder(
itemCount: tempSearchstore.length,
                itemBuilder: (BuildContext context, int index) {
  return secard(tempSearchstore[index]);
                },

            );
          }
      )*/:Text("Post"),
    );
  }
}
