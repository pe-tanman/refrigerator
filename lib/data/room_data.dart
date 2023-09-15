class RoomDetailData {
  final String title;
  final String imgPath;

  const RoomDetailData({required this.title, required this.imgPath});
}

class RoomData {
  static const RoomDetailData firstRoom = RoomDetailData(
      title: "タマゴの部屋", imgPath: "assets/Image/1stStage_background.png");
  static const RoomDetailData secondRoom = RoomDetailData(
      title: "干物の部屋", imgPath: "assets/Image/2neStage_background.png");
  static const RoomDetailData thirdRoom = RoomDetailData(
      title: "調理室", imgPath: "assets/Image/3rdStage_background.png");
  static const RoomDetailData forthRoom = RoomDetailData(
      title: "細道", imgPath: "assets/Image/4thStage_background.png");

  static RoomDetailData? roomData(int room) {
    switch (room) {
      case 1:
        return firstRoom;
      case 2:
        return secondRoom;
      case 3:
        return thirdRoom;
      case 4:
        return forthRoom;
      default:
        return null;
    }
  }
}
