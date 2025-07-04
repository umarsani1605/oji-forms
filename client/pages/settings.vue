<template>
  <div class="bg-white">
    <div class="flex bg-gray-50">
      <div class="max-w-6xl w-full mx-auto px-6">
        <div class="pt-4 pb-0">
          <div class="flex">
            <h2 class="flex-grow text-gray-900">
              My Account
            </h2>
          </div>
          <ul class="flex text-gray-500">
            <li>{{ user.email }}</li>
          </ul>

          <div class="mt-4 border-gray-200 dark:border-gray-700">
            <ul class="flex flex-wrap -mb-px text-sm font-medium text-center">
              <li
                v-for="(tab, i) in tabsList"
                :key="i + 1"
                class="mr-6"
              >
                <nuxt-link
                  :to="{ name: tab.route }"
                  class="hover:no-underline inline-block py-4 rounded-t-lg border-b-2 text-gray-500 hover:text-gray-600"
                  active-class="text-emerald-600 hover:text-emerald-900 dark:text-emerald-500 dark:hover:text-emerald-500 border-emerald-600 dark:border-emerald-500"
                >
                  {{ tab.name }}
                </nuxt-link>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="flex bg-white">
      <div class="max-w-6xl w-full mx-auto px-6">
        <div class="mt-4 pb-0">
          <NuxtPage />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from "vue"
import { useAuthStore } from "../stores/auth"

definePageMeta({
  middleware: ["auth", "self-hosted-credentials"],
})

useOpnSeoMeta({
  title: "Settings",
})

const authStore = useAuthStore()
const user = computed(() => authStore.user)
const workspace = computed(() => useWorkspacesStore().getCurrent)
const tabsList = computed(() => {
  const tabs = [
    {
      name: "Profile",
      route: "settings-profile",
    },
    {
      name: "Workspace Settings",
      route: "settings-workspace",
    },
    ...workspace.value.is_readonly ? [] : [
      {
        name: "Access Tokens",
        route: "settings-access-tokens",
      },
      {
        name: "Connections",
        route: "settings-connections",
      },
    ],
    {
      name: "Password",
      route: "settings-password",
    },
    {
      name: "Delete Account",
      route: "settings-account",
    },
  ]

  if (user?.value?.has_customer_id) {
    tabs.splice(1, 0, {
      name: "Billing",
      route: "settings-billing",
    })
  }

  if (user?.value?.admin) {
    tabs.push({
      name: "Admin",
      route: "settings-admin",
    })
  }

  return tabs
})
</script>
