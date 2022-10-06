import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forum3/Services/Firestoremethods.dart';
import 'package:forum3/shared/Pop_up.dart';
import 'package:forum3/shared/Widgets/Comment_card.dart';
import 'package:provider/provider.dart';

import '../../../Models/Users1.dart';
import '../../../Provider/user_provider.dart';

//TODO:Replace code

class GcommentsScreen extends StatefulWidget {
  final snap;
  final groupid;
  const GcommentsScreen({Key? key,this.snap,this.groupid}) : super(key: key);

  @override
  State<GcommentsScreen> createState() => _GcommentsScreenState();
}

class _GcommentsScreenState extends State<GcommentsScreen> {
dynamic image;

  commenting(String postid, String textt,String author_uid,String author,String ppurl,String title,String onweruid) async{
    String ress=await FirestoreMethods().postcomment(postid, textt, author_uid, author, ppurl,title,onweruid);
    if( ress=="Comment success"){
      Showsnackbar(ress, context);
    }else if(ress=="Empty field"){
      ress="Please Enter text";
      Showsnackbar(ress, context);
    }else{
      Showsnackbar(ress, context);
    }
    setState(() {
      text.text="";
    });

  }
  TextEditingController text=TextEditingController();

  @override
  void dispose() {
text.dispose();
    super.dispose();
  }

  Widget Avatar(dynamic image,User1 user1){
    try{
      return image!=null?  CircleAvatar(
        radius: 20,
        backgroundImage: MemoryImage(image),
      ):user1.ppurl!=""? CircleAvatar(
        backgroundImage: NetworkImage(user1.ppurl!),
        radius: 20,
      ):const CircleAvatar(
        backgroundImage: AssetImage('Assets/hac.jpg'),
        radius: 20,
      );
    }
    catch(e){
      return const CircleAvatar(
        backgroundImage: AssetImage('Assets/hac.jpg'),
        radius: 20,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    late  User1 user1=  Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title:const Text(
          "Discussion",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Posts").doc(widget.snap['Post Uid']).collection("comments").orderBy("Comment Time",descending: true).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshots){
            if(snapshots.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  child: Commentcard(
                    snap: snapshots.data!.docs[index].data(),
                    postid: widget.snap['Post Uid'],
                  ),
                )
            );
          }
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            child: Row(
              children: [
               Avatar(image, user1) ,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 1.0
                    ),
                    child: TextField(
                      controller: text,
                      decoration: InputDecoration(
                        hintText: "Comment as ${user1.Username}",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: ()async{
                     try {
                      
                     }catch(e){
                       Showsnackbar(e.toString(), context);
                     }
                      },
                    child: const Text("Post"),
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.black,
                      primary: Colors.lightBlueAccent,
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
