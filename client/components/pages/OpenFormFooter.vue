<template>
  <div class="w-full">
    <div class="flex justify-center my-2">
      <div class="flex items-center">
        <p class="text-sm text-gray-600 dark:text-gray-400 text-center w-full">
          Omah Ngaji Al-Anshori © {{ currYear }}.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import opnformConfig from "~/opnform.config.js"

const authStore = useAuthStore()

const user = computed(() => authStore.user)
const currYear = ref(new Date().getFullYear())

// Use the reactive version for proper template reactivity
const version = computed(() => useFeatureFlag('version'))
</script>
