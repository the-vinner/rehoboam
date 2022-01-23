import { routeNames } from './routeNames'
import { RouteRecordRaw } from 'vue-router'
import RouteContent from './RouteContent/RouteContent'
import RouteLogin from './RouteLogin/RouteLogin'

const routes : RouteRecordRaw[] = [
  {
    name: routeNames.content,
    path: '/',
    component: RouteContent
  },
  {
    name: routeNames.login,
    path: '/login',
    component: RouteLogin
  },
  {
    name: routeNames.loginError,
    path: '/login/error',
    component: () => import('./RouteLoginError/RouteLoginError')
  },
  {
    name: routeNames.schema,
    path: '/schemas/:id/:fieldId?',
    component: () => import('./RouteSchema/RouteSchema')
  },
  {
    name: routeNames.error,
    path: '/:pathMatch(.*)*',
    component: () => import('./RouteError/RouteError')
  }
]
export default routes