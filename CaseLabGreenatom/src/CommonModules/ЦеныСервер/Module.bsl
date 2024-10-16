#Область ПрограммныйИнтерфейс

Функция ЦенаНаДату(Номенклатура, Дата) Экспорт
	
	ТекстЗапроса = 	"ВЫБРАТЬ
	               	|	ЦеныСрезПоследних.ЦенаБезНДС КАК Цена,
	               	|	ЦеныСрезПоследних.Номенклатура КАК Номенклатура
	               	|ИЗ
	               	|	РегистрСведений.Цены.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК ЦеныСрезПоследних";
	                	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ВыгрузкаИзЗапроса = РезультатЗапроса.Выгрузить();
	
    ПоследняяЦенаНоменклатуры = ВыгрузкаИзЗапроса[0].Цена;
	
	Возврат ПоследняяЦенаНоменклатуры;
	
КонецФункции

Функция ПоследняяЦенаКурьера(Контрагент, Дата) Экспорт
	
	Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию("Доставка", Истина);
   
	ТекстЗапроса = 	"ВЫБРАТЬ
	               	|	ЦеныСрезПоследних.ЦенаБезНДС КАК Цена,
	               	|	ЦеныСрезПоследних.Номенклатура КАК Номенклатура,
	               	|	ЦеныСрезПоследних.Контрагент КАК Контрагент,
	               	|	ЦеныСрезПоследних.СтавкаНДС КАК СтавкаНДС
	               	|ИЗ
	               	|	РегистрСведений.Цены.СрезПоследних(
	               	|			&Дата,
	               	|			Номенклатура = &Номенклатура
	               	|				И Контрагент = &Контрагент) КАК ЦеныСрезПоследних";
					
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ВыгрузкаИзЗапроса = РезультатЗапроса.Выгрузить();
	
	ПоследняяЦенаКурьера = ВыгрузкаИзЗапроса[0].Цена; 
	СтавкаНДС = ВыгрузкаИзЗапроса[0].СтавкаНДС;
	
	Структура = Новый Структура;
	Структура.Вставить("Номенклатура", Номенклатура);
	Структура.Вставить("Цена", ПоследняяЦенаКурьера);
	Структура.Вставить("СтавкаНДС", СтавкаНДС);
	
	Возврат Структура;
	
КонецФункции	

#КонецОбласти


