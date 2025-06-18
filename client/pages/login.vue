<template>
  <div class="flex flex-col items-center justify-center w-screen h-dvh md:bg-slate-100">
    <div class="card w-[500px] p-12 bg-white rounded-2xl md:shadow-sm">
      <div class="flex justify-center mb-12">
        <img src="/img/logo.png" alt="logo" class="h-24" />
      </div>

      <h1 class="text-3xl font-bold text-center text-gray-900 mb-4">Login</h1>

      <login-form />
    </div>
  </div>
</template>

<script setup>
import LoginForm from "~/components/pages/auth/components/LoginForm.vue"

definePageMeta({
  middleware: "guest",
  layout: "basic",
})
useOpnSeoMeta({
  title: "Login",
})
</script>

<style scoped>
.card {
  box-shadow: 0px 4px 30px rgba(221, 224, 255, 0.54);
}
</style>
