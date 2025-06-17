<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-50">
    <div class="card w-[400px] p-12 bg-white rounded-2xl">
      <div class="flex justify-center mb-12">
        <img src="/img/logo.png" alt="logo" class="h-20" />
      </div>

      <h1 class="text-3xl font-bold text-center text-gray-900 mb-2">Login</h1>
      <p class="text-center text-gray-500 mb-8">Silahkan masukkan kredensial Anda</p>

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
