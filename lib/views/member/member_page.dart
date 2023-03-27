import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:E_Library/controllers/member_controller.dart';
import 'package:E_Library/models/member_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/core/app_screen_size_helper.dart';
import 'package:E_Library/utils/core/app_theme.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/loading.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  bool isLoading = false;
  bool isLoadMore = false;
  bool isEnd = false;
  int page = 1;

  UserModel? userModel;
  late MemberController memberController;
  List<MemberModel> member= <MemberModel>[];
  List<MemberModel> listMember= <MemberModel>[];
  TextEditingController searchController = new TextEditingController();

  setLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    isEnd = false;
    memberController = new MemberController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    listMember.clear();

    await getListMember();
  }
  
  getListMember() async {
    await memberController.memberListGet(context, setLoadingState, setMember, page, member: searchController.text);
  }

  setMember(data) {
    if (data is List<MemberModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          member = data;
          listMember.addAll(member);
        });
      }
    }
  }

  refreshData() async {
    listMember.clear();
    page = 1;
    await getListMember();
  }

  _loadMoreData() async {
    await getListMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(right: 15),
            child: Image(
              height: 50,
              image: AssetImage("assets/images/logo/logo.png"), 
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey2,
              border: Border.all(
                color: AppTheme.lightGrey2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (val) async {
                initData();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "List Member",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: ScreenSizeHelper.getDisplayWidth(context),
              child: RefreshIndicator(
                onRefresh: () async {
                  refreshData();
                },
                child: isLoading ? Loading.circularLoading() : LazyLoadScrollView(
                  scrollOffset: 2,
                  isLoading: isLoadMore,
                  onEndOfPage: () async {
                    if (!isLoadMore && !isEnd) {
                      setState(() {
                        page++;
                      });
                      await _loadMoreData();
                    }
                  },
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listMember.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, listMember[index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ListTile(
                                title: Text(
                                  listMember[index].name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colorPrimaryDark
                                  ),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}