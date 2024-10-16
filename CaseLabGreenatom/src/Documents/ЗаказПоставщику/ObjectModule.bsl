#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ТекущийСотрудникСервер.СотрудникТекущегоПользователя();
	Адрес = "г.Москва, ул.Б.Ордынка, д.26";
	Статус = Перечисления.СтатусЗаказаПоставщика.Создан;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = "ЗП";
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Статус = Перечисления.СтатусЗаказаПоставщика.Отменен;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказПоставщикуПозиции.Наименование КАК Наименование,
	|	ЗаказПоставщикуПозиции.Наименование.ОбъемУпаковки КАК ОбъемУпаковки,
	|	ЗаказПоставщикуПозиции.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ЗаказПоставщику.Позиции КАК ЗаказПоставщикуПозиции
	|ГДЕ
	|	ЗаказПоставщикуПозиции.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Для Каждого Строка Из Позиции Цикл
			
			Если Строка.Наименование <> ВыборкаДетальныеЗаписи.Наименование Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			Если ВыборкаДетальныеЗаписи.ОбъемУпаковки = 0 Тогда
			
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Заполните объем упаковки для позиции %1", ВыборкаДетальныеЗаписи.Наименование);
				Сообщение.Поле = "Объект.Позиции[ВыборкаДетальныеЗаписи.НомерСтроки].Наименование";
				Сообщение.Сообщить();
				
				Возврат;
							
			КонецЕсли;
						
			Если Строка.Количество < ВыборкаДетальныеЗаписи.ОбъемУпаковки Тогда
				
				Строка.Количество = ВыборкаДетальныеЗаписи.ОбъемУпаковки;
				Строка.Сумма = Строка.Количество * Строка.Цена;
				Строка.СуммаНДС = НДССервер.СуммаНДСПоСтавке(Строка.Сумма, Строка.СтавкаНДС);
				Строка.СуммаСНДС = Строка.Сумма + Строка.СуммаНДС;
				
				Сообщить(СтрШаблон("Для позиции %1 количество увеличено до целой упаковки.", ВыборкаДетальныеЗаписи.Наименование)); 
                			
			ИначеЕсли Строка.Количество > ВыборкаДетальныеЗаписи.ОбъемУпаковки Тогда
				
				КоличествоУпаковок = КоличествоУпаковокСервер.КоличествоУпаковок(Строка.Количество, ВыборкаДетальныеЗаписи.ОбъемУпаковки);
				
				Строка.Количество = КоличествоУпаковок * ВыборкаДетальныеЗаписи.ОбъемУпаковки;
				Строка.Сумма = Строка.Количество * Строка.Цена;
				Строка.СуммаНДС = НДССервер.СуммаНДСПоСтавке(Строка.Сумма, Строка.СтавкаНДС);
				Строка.СуммаСНДС = Строка.Сумма + Строка.СуммаНДС;
				
				Сообщить(СтрШаблон("Для позиции %1 количество увеличено до целой упаковки. ", ВыборкаДетальныеЗаписи.Наименование));
				
			КонецЕсли;
			
		КонецЦикла;
			
	КонецЦикла;
	
	Статус = Перечисления.СтатусЗаказаПоставщика.НаправленПоставщику;

КонецПроцедуры

#КонецОбласти  

#Область СлужебныеПроцедурыИФункции


	
#КонецОбласти