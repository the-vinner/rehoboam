import { defineComponent, Suspense } from 'vue'

export default defineComponent({
  name: 'App',
  setup () {

    return () => {
      return <div id="main">
        <div>Hello</div>
        <Suspense>
          <router-view class="flex-1" />
        </Suspense>
      </div>
    }
  }
})