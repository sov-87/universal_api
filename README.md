https://travis-ci.org/sov-87/universal_api.svg

Универсальный API
-----------------

This project provides REST interface for ActiveRecord models - CRUD operations.

Follow MVC, put business logic in models, build rich javascript applications based on REST.
All other work from building queries with help of [ransack](https://github.com/activerecord-hackery/ransack)
up to generating JSON or XML response UniversalApi will do for you.
Create, update and delete data through ActiveRecord model methods via http requests.

You can access models via REST by url `/universal_api/<класс модели>`.

Search is provided by [ransack](https://github.com/activerecord-hackery/ransack), so you can access all of it's features - search by model's fields (query parameter q), sorting (query parameter q[s]), [creating and using scopes using q[\<scope name\>]](https://github.com/activerecord-hackery/ransack#using-scopesclass-methods).

Also you can limit result by setting query param `limit` and explicity set result columns with `select[]`.
By default you can access only columns of current model's table,
but you can override method `extra_select_values` in your child controller.


Предоставляет доступ с использованием REST по ссылке вида `/universal_api/<класс модели>`

Для поиска используется [ransack](https://github.com/activerecord-hackery/ransack),
соответственно можно использовать все его возможности - поиск по полям модели и по ассоциациям (параметр запроса q),
сортировка (параметр запроса q[s]),
[создание scope-ов и их последующее использование через q[\<наименование scope\>]](https://github.com/activerecord-hackery/ransack#using-scopesclass-methods).

Если необходимо передавать параметры в ransack как с клиента, так и задавать в маршрутах,
то надо использовать в маршрутах параметр q_defaults для передачи параметров.

Также реализованы ограничение количества записей с помощью параметра запроса `limit` и указание столбцов для выдачи с помощью параметра select[].
По-умолчанию для выбора доступны только столбцы текущей таблицы,
однако можно переопределить метод extra_select_values в контроллере,
унаследованном от контроллера универсального API, для задания любых значений.

Частые задачи и способы их решения
 - необходимо получить данные специальным запросом, причем в запросе не требуются параметры http-запроса и значения из сессии:
 - создать scope в соответствующей модели
 - добавить его в ransackable_scopes
 - если действие не должно быть общедоступным, то создать соответствующий маршрут и направить его на index, в параметрах указав нужный scope. Подробнее про механизм написано [Здесь](https://github.com/activerecord-hackery/ransack#using-scopesclass-methods)
```
  # у нас есть отдельный контроллер, в котором не переопределен index
  controller '<имя контроллера>' do
    get '<имя scope>', action: 'index', defaults: { q: { <имя scope>: true } }
  end

  # когда надо создать видимость реального ресурса
  scope: '<имя контроллера>' do
    get '<имя scope>'=> 'universal_api#index', defaults: { q: { <имя scope>: true } }
  end

  # когда не требуется создавать видимость реального ресурса
  # добавить ПЕРЕД секцией universal_api
  controller: 'universal_api' do
    get '/класс модели/имя scope>',
      action: 'index',
      defaults: { model_name: 'класс модели', q: { <имя scope>: true } }
  end
```

This project rocks and uses MIT-LICENSE)
