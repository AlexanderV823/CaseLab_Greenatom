#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	Документы.ЗаказПоставщику.Печать(ТабДок, ПараметрКоманды);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

  &НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	
	ТабДок = Новый ТабличныйДокумент;
	Печать(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Истина;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

#КонецОбласти