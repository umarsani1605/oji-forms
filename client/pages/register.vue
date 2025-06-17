<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-50">
    <div class="card w-[400px] p-12 bg-white rounded-2xl">
      <div class="flex justify-center mb-12">
        <img src="/img/logo.png" alt="logo" class="h-20" />
      </div>

      <h1 class="text-3xl font-bold text-center text-gray-900 mb-2">Register</h1>
      <p class="text-center text-gray-500 mb-8">Buat akun baru dalam hitungan menit</p>

      <template v-if="!useFeatureFlag('self_hosted') || isInvited">
        <register-form />
      </template>
      <div
        v-else
        class="my-6 p-3 rounded-lg border border-yellow-600 bg-yellow-200 text-yellow-600"
      >
        Registration is not allowed in self host mode.
      </div>
    </div>
  </div>
</template>

<script>
import RegisterForm from "~/components/pages/auth/components/RegisterForm.vue"
import AppSumoRegister from "~/components/vendor/appsumo/AppSumoRegister.vue"

export default {
  components: {
    AppSumoRegister,
    RegisterForm,
  },

  setup() {
    useOpnSeoMeta({
      title: "Register",
    })

    definePageMeta({
      middleware: ["self-hosted", "guest"],
      layout: "basic",
    })

    defineRouteRules({
      swr: 3600,
    })
    return {
      appStore: useAppStore(),
    }
  },

  data: () => ({}),

  computed: {
    isInvited() {
      return this.$route.query?.email && this.$route.query?.invite_token
    }
  },

  methods: {},
}
</script>

<style scoped>
.card {
  box-shadow: 0px 4px 30px rgba(221, 224, 255, 0.54);
}
</style>
