import './App.css'
import { defineComponent, Suspense } from 'vue'

export default defineComponent({
  name: 'App',
  setup () {

    return () => {
      return <div id="main">
          <Suspense>
            <router-view class="flex-1" />
          </Suspense>
      </div>
    }
  }
})