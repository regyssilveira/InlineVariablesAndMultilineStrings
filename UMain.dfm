object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object BtnMultiLineStrings: TButton
    Left = 8
    Top = 8
    Width = 251
    Height = 25
    Caption = 'Multiline strings'
    TabOrder = 0
    OnClick = BtnMultiLineStringsClick
  end
  object Memo1: TMemo
    Left = 265
    Top = 8
    Width = 355
    Height = 425
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object BtnInLineVars: TButton
    Left = 8
    Top = 39
    Width = 251
    Height = 25
    Caption = 'Inline vars'
    TabOrder = 2
    OnClick = BtnInLineVarsClick
  end
  object BtnEscope: TButton
    Left = 8
    Top = 70
    Width = 251
    Height = 25
    Caption = 'Escope'
    TabOrder = 3
    OnClick = BtnEscopeClick
  end
end
