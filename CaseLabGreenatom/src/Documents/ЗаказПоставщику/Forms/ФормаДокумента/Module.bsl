
#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПозиции

&НаКлиенте
Процедура ПозицииНаименованиеПриИзменении(Элемент)
	
	ПриИзмененииНоменклатуры(Элементы.Позиции.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Позиции.ТекущиеДанные;
	
	ПриИзмененииКоличества(Элементы.Позиции.ТекущиеДанные);
	
	Если ТекущаяСтрока.Количество > 0 Тогда
		
		ТекущаяСтрока.Цена = ТекущаяСтрока.Сумма / ТекущаяСтрока.Количество;
		
	Иначе
		
		ТекущаяСтрока.Цена = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииЦенаПриИзменении(Элемент)
	
	ПриИзмененииЦены(Элементы.Позиции.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Позиции.ТекущиеДанные;
	
	ПриИзмененииСуммы(ТекущаяСтрока);
	
	Если ТекущаяСтрока.Количество > 0 Тогда
		
		ТекущаяСтрока.Цена = ТекущаяСтрока.Сумма / ТекущаяСтрока.Количество;
		
	Иначе
		
		ТекущаяСтрока.Цена = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииСтавкаНДСПриИзменении(Элемент)
	
	ПриИзмененииСтавкиНДС(Элементы.Позиции.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииНоменклатуры(ИзмененнаяСтрока)

    Если ЗначениеЗаполнено(ИзмененнаяСтрока.Наименование) Тогда
		
		Цена = ЦеныВызовСервера.ЦенаНаДату(ИзмененнаяСтрока.Наименование, КонецДня(Объект.Дата));
		ИзмененнаяСтрока.Цена = Цена;
				  	
		Номенклатура = ИзмененнаяСтрока.Наименование;		
		СтавкаНДС = СтавкаНДС(Номенклатура);
        ИзмененнаяСтрока.СтавкаНДС = СтавкаНДС;
		
	Иначе
				
		Возврат;
		
	КонецЕсли;
	
	ПриИзмененииЦены(ИзмененнаяСтрока);
	ПриИзмененииСтавкиНДС(ИзмененнаяСтрока);
	
КонецПроцедуры

&НаСервере
Функция СтавкаНДС(Номенклатура)

	Запрос = Новый Запрос;
	Запрос.Текст = 
					"ВЫБРАТЬ
					|	Номенклатура.СтавкаНДС КАК СтавкаНДС
					|ИЗ
					|	Справочник.Номенклатура КАК Номенклатура
					|ГДЕ
					|	Номенклатура.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Возврат ВыборкаДетальныеЗаписи.СтавкаНДС;
		
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииКоличества(ИзмененнаяСтрока)
	
	Если Не ЗначениеЗаполнено(ИзмененнаяСтрока.Цена) Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	ПересчетКоличестваИСуммы(ИзмененнаяСтрока);
	ПриИзмененииСуммы(ИзмененнаяСтрока);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриИзмененииЦены(ИзмененнаяСтрока)
	
	ПересчетКоличестваИСуммы(ИзмененнаяСтрока);
	ПриИзмененииСуммы(ИзмененнаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчетКоличестваИСуммы(ИзмененнаяСтрока)
	
	Если ИзмененнаяСтрока = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИзмененнаяСтрока.Сумма = ИзмененнаяСтрока.Количество * ИзмененнаяСтрока.Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСуммы(ИзмененнаяСтрока)
	
	Если ИзмененнаяСтрока = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИзмененнаяСтрока.Количество) Или Не ЗначениеЗаполнено(ИзмененнаяСтрока.Цена) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИзмененнаяСтрока.СуммаНДС = НДСКлиент.СуммаНДСПоСтавке(ИзмененнаяСтрока.Сумма, ИзмененнаяСтрока.СтавкаНДС);
	ИзмененнаяСтрока.СуммаСНДС = ИзмененнаяСтрока.Сумма + ИзмененнаяСтрока.СуммаНДС;
			
КонецПроцедуры 

&НаКлиенте
Процедура ПриИзмененииСтавкиНДС(ИзмененнаяСтрока)
	
	Если Не ЗначениеЗаполнено(ИзмененнаяСтрока.Сумма) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИзмененнаяСтрока.СуммаНДС = НДСКлиент.СуммаНДСПоСтавке(ИзмененнаяСтрока.Сумма, ИзмененнаяСтрока.СтавкаНДС);
	ИзмененнаяСтрока.СуммаСНДС = ИзмененнаяСтрока.Сумма + ИзмененнаяСтрока.СуммаНДС;
	
КонецПроцедуры

#КонецОбласти