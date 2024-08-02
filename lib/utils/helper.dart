import 'dart:convert';

errorhandler(dynamic response)
{
  switch(response.statuscode)
  {
    case  401:throw Exception(jsonDecode(response.body)['message']);
    default:Exception('Something went wrong');
  }
}
