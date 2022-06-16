object frmBloqueiaSysdba: TfrmBloqueiaSysdba
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Kyrius - Firebird Install (Migrador Fb 2.5/3.0 para 4.0'
  ClientHeight = 650
  ClientWidth = 753
  Color = 15921906
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 11
    Width = 729
    Height = 582
  end
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 70
    Height = 13
    Caption = 'Caminho BD:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object labConectado: TLabel
    Left = 39
    Top = 176
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 32
    Top = 66
    Width = 72
    Height = 13
    Caption = 'Usu'#225'rio ADM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 148
    Top = 66
    Width = 35
    Height = 13
    Caption = 'Senha'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 331
    Top = 16
    Width = 3
    Height = 193
  end
  object editPath: TEdit
    Left = 32
    Top = 37
    Width = 229
    Height = 21
    TabOrder = 0
    Text = 'dsknery/3051:kyrius.top1'
  end
  object Button1: TButton
    Left = 268
    Top = 35
    Width = 48
    Height = 25
    Hint = 'Selecione o Banco de Dados...'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object btConexao: TButton
    Left = 99
    Top = 116
    Width = 102
    Height = 43
    Cursor = crHandPoint
    Caption = 'Conectar'
    TabOrder = 2
    OnClick = btConexaoClick
  end
  object editUserDBA: TEdit
    Left = 32
    Top = 80
    Width = 107
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
    Text = 'SYSDBA'
  end
  object editSenhaDBA: TEdit
    Left = 150
    Top = 80
    Width = 111
    Height = 21
    TabOrder = 4
    Text = 'masterkey'
  end
  object Memo1: TMemo
    Left = 1016
    Top = 398
    Width = 2000
    Height = 403
    TabOrder = 5
    Visible = False
  end
  object MemoResultado: TMemo
    Left = 32
    Top = 217
    Width = 688
    Height = 363
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object panelProcessar: TPanel
    Left = 347
    Top = 24
    Width = 384
    Height = 135
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 7
    Visible = False
    object Label6: TLabel
      Left = 0
      Top = 0
      Width = 223
      Height = 13
      Caption = 'Caminho da instala'#231#227'o do Firebird Atual'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 0
      Top = 48
      Width = 362
      Height = 13
      Caption = 'Caminho do Sistema (Para onde ser'#227'o copiadas as Dlls do Fb4.0)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button2: TButton
      Left = 127
      Top = 92
      Width = 102
      Height = 43
      Cursor = crHandPoint
      Caption = 'Processar'
      TabOrder = 0
      OnClick = Button2Click
    end
    object EditCaminhoFB: TEdit
      Left = 1
      Top = 13
      Width = 331
      Height = 21
      TabOrder = 1
    end
    object Button3: TButton
      Left = 336
      Top = 11
      Width = 48
      Height = 25
      Hint = 'Defina o caminho do Firebird...'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button3Click
    end
    object editPathSistema: TEdit
      Left = 1
      Top = 65
      Width = 331
      Height = 21
      TabOrder = 3
    end
    object Button4: TButton
      Left = 336
      Top = 63
      Width = 48
      Height = 25
      Hint = 'Defina o caminho do Firebird...'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = Button4Click
    end
  end
  object BitBtn1: TBitBtn
    Left = 652
    Top = 600
    Width = 85
    Height = 39
    Cursor = crHandPoint
    Caption = 'Sair'
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 8
    OnClick = BitBtn1Click
  end
  object FDConexao: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Left = 808
    Top = 224
  end
  object FDQuery: TFDQuery
    Connection = FDConexao
    Left = 808
    Top = 352
  end
  object FDScript1: TFDScript
    SQLScripts = <>
    Connection = FDConexao
    Params = <>
    Macros = <>
    Left = 808
    Top = 288
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConexao
    Left = 808
    Top = 424
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.fdb'
    Left = 440
    Top = 32
  end
end
