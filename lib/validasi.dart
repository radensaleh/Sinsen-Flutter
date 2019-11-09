class Validasi{

  String validasiPassword(String value){
    if(value.length < 4){
      return 'minimal 4';
    }
    return null;
  }

  String validasiEmail(String value){
    if(value.length < 4){
      return 'minimal 4';
    }
    return null;
  }
}