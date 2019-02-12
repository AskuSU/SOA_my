 unit webMainMod;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd;

type
  TWebModule2 = class(TWebModule)
    PageProducer1: TPageProducer;
    procedure WebModule2DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule2acAuthAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModule2acFileAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule2;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}
uses
  System.JSON;

procedure TWebModule2.PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString='something' then begin
    ReplaceText := '<form action="/auth">'+
    'username:<br>'+
    '<input type="text" name="username" value="����">'+
    '<br>password:<br>'+
    '<input type="text" name="password" value="������">'+
    '<br><br>'+
    '<input type="submit" value="login">'+
    '</form>';

  end;
end;

procedure TWebModule2.WebModule2acAuthAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  params, respObj: TJSONObject;
  usernm, passw: string;
begin
  if Request.MethodType <> mtPost then begin
    Handled:=False;
    exit;
  end;
  //  Response.Content := Request.Content;
  Params := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Request.Content),0) as TJSONObject;
  usernm := Params.Values['username'].ToString;
  passw := Params.Values['password'].ToString;
  Response.ContentType := 'application/json';
  respObj:= TJSONObject.Create;
  try
    respObj.AddPair('status','�������');
    Response.Content := respObj.ToJSON;
  finally
    respObj.DisposeOf;
  end;
end;

procedure TWebModule2.WebModule2acFileAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  FS: TFileStream;
  RequestedFile: string;
begin
  Handled:=True;
  GetDir(0,RequestedFile);
  RequestedFile := RequestedFile + '\Page1.html';
  //RequestedFile := RequestedFile + '\new3.html';
  if not FileExists(RequestedFile) then begin
    Response.StatusCode:=404;
    exit;
  end;
  FS:= TFileStream.Create(RequestedFile,fmOpenRead);

    Response.ContentType:='html';
    Response.ContentStream :=FS;
end;

procedure TWebModule2.WebModule2DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application ������</body>' +
    '</html>';
end;

end.
