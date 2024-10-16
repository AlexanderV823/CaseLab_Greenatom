#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
 Изображение = "";
 
 ЗначениеКлюча = Новый Структура;
 ЗначениеКлюча.Вставить("Номенклатура", Объект.Ссылка);
 
 ЗаписьВРегистр = РегистрыСведений.Изображения.СоздатьКлючЗаписи(ЗначениеКлюча);
 
 Изображение = ПолучитьНавигационнуюСсылку(ЗаписьВРегистр, "Изображение", 0);
 
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МенеджерЗаписи = РегистрыСведений.Изображения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура = Объект.Ссылка;
	
	Если ЭтоАдресВременногоХранилища(Изображение) Тогда
		
		ДвоичнвеДанные = ПолучитьИзВременногоХранилища(Изображение);
		
		МенеджерЗаписи.Изображение = Новый ХранилищеЗначения(ДвоичнвеДанные); 
		МенеджерЗаписи.Записать();
		
	ИначеЕсли Изображение = "" Тогда
		
		МенеджерЗаписи.Фото = Новый ХранилищеЗначения(Неопределено);
		МенеджерЗаписи.Записать();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)

	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипНоменклатуры.Блюдо") Тогда
		
		Элементы.Ингредиенты.Видимость = Истина;
		
	Иначе
		
		Элементы.Ингредиенты.Видимость = Ложь;
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипНоменклатуры.Блюдо") И ЗначениеЗаполнено(Объект.Ингредиенты) Тогда
		
		Отказ = Истина;
		Сообщить("Нельзя заполнить вкладку ""Ингредиенты"" для расходного материала, ингридиента или услуги! 
				|Очистите вкладку ""Ингредиенты"" или выберите тип ""Готовый продукт""."); 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипНоменклатуры.Блюдо") Тогда
		
		Элементы.Ингредиенты.Видимость = Истина;
		
	Иначе
		
		Элементы.Ингредиенты.Видимость = Ложь;
		
	КонецЕсли	
	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнгредиенты

 &НаКлиенте
Процедура ИнгредиентыПродуктОбработкаВыбора(Элемент, ВыбранноеЗначение, ДополнительныеДанные, СтандартнаяОбработка)
	
	ЕдиницаИзмерения = ЕдиницаИзмеренияНаСервере(ВыбранноеЗначение);
	
	ТекущаяСтрока = Элементы.Ингредиенты.ТекущиеДанные;
	
	ТекущаяСтрока.ЕдиницаИзмерения = ЕдиницаИзмерения;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзображение(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузкаИзображения", ЭтотОбъект);
	НачатьПомещениеФайлаНаСервер(Оповещение, , , , , УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузкаИзображения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		
		Возврат
		
	КонецЕсли;
	
	Изображение = Результат.Адрес;
	
КонецПроцедуры 

&НаКлиенте
Процедура УдалитьИзображение(Команда)
	
	Изображение = "";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕдиницаИзмеренияНаСервере(ВыбранноеЗначение)
	
      ЕдиницаИзмерения = ВыбранноеЗначение.ЕдиницаИзмерения;
	  
	  Возврат ЕдиницаИзмерения;

КонецФункции

 #КонецОбласти



