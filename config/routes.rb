Rails.application.routes.draw do
   
  root 'menus#index'

  #メニュー
  get    'menus/show/:id',   to: 'menus#show',    as: 'menu_show'
  get    'menus/new',        to: 'menus#new',     as: 'menu_new'
  post   'menus/create',     to: 'menus#create',  as: 'menu_create'
  get    'menus/edit/:id',   to: 'menus#edit',    as: 'menu_edit'
  patch  'menus/update/:id', to: 'menus#update',  as: 'menu_update'
  delete 'menus/delete/:id', to: 'menus#destroy', as: 'menu_delete'

  #材料
  get    'ingredient/index',      to: 'ingredients#index',   as: 'ing_index'
  get    'ingredient/new',        to: 'ingredients#new',     as: 'ing_new'
  post   'ingredient/create',     to: 'ingredients#create',  as: 'ing_create'
  get    'ingredient/edit/:id',   to: 'ingredients#edit',    as: 'ing_edit'
  patch  'ingredient/update/:id', to: 'ingredients#update',  as: 'ing_update'
  delete 'ingredient/delete/:id', to: 'ingredients#destroy', as: 'ing_delete'

  #ユーザー
  get    'users/new',        to: 'users#new',    as:  'user_new'
  post   'users/create',     to: 'users#create', as:  'user_create'
  get    'users/edit/:id',   to: 'users#edit',   as:  'user_edit'
  patch  'users/update/:id', to: 'users#update', as:  'user_update'
  delete 'users/delete/:id', to: 'users#destroy', as: 'user_delete'
  
  #ログイン/ログアウト
  get    'login',           to: 'sessions#new',         as: 'login'
  post   'sessions/create', to: 'sessions#create',      as: 'login_create'
  delete 'logout',          to: 'sessions#destroy',     as: 'logout'
  get    'admin_login',     to: 'sessions#admin_login', as: 'admin_login'

  #カート保存/削除
  get    'carts/list',      to: 'carts#index',   as: 'cart_list'
  post   'index/carts/in2', to: 'carts#create',  as: 'index_cart_in'
  patch  'carts/in',        to: 'carts#update',  as: 'cart_in'
  delete 'carts/out',       to: 'carts#destroy', as: 'cart_out'

  #注文
  get  'orders/index',  to: 'orders#index',  as: 'order'
  get  'orders/new',    to: 'orders#new',    as: 'order_new'
  post 'orders/check',  to: 'orders#check',  as: 'order_check'
  post 'orders/create', to: 'orders#create', as: 'order_create'
  get  'orders/fin',    to: 'orders#fin',    as: 'order_fin'
end
