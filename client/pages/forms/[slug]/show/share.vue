<template>
  <div class="max-w-6xl w-full mx-auto p-6">
    <div class="mb-20">
      <div class="mb-6 pb-6 border-b w-full flex flex-col sm:flex-row gap-2">
        <regenerate-form-link
          v-if="!workspace.is_readonly"
          class="sm:w-1/2 flex"
          :form="props.form"
        />

        <url-form-prefill
          class="sm:w-1/2"
          :form="props.form"
          :extra-query-param="shareUrlForQueryParams"
        />

        <embed-form-as-popup-modal
          class="sm:w-1/2 flex"
          :form="props.form"
        />
      </div>

      <share-link
        class="mt-4"
        :form="props.form"
        :extra-query-param="shareUrlForQueryParams"
      />

      <embed-code
        class="mt-6"
        :form="props.form"
        :extra-query-param="shareUrlForQueryParams"
      />

      <form-qr-code
        class="mt-6"
        :form="props.form"
        :extra-query-param="shareUrlForQueryParams"
      />

      <advanced-form-url-settings
        v-model="shareFormConfig"
        :form="props.form"
      />
    </div>
  </div>
</template>

<script setup>
import ShareLink from "~/components/pages/forms/show/ShareLink.vue"
import EmbedCode from "~/components/pages/forms/show/EmbedCode.vue"
import FormQrCode from "~/components/pages/forms/show/FormQrCode.vue"
import UrlFormPrefill from "~/components/pages/forms/show/UrlFormPrefill.vue"
import RegenerateFormLink from "~/components/pages/forms/show/RegenerateFormLink.vue"
import AdvancedFormUrlSettings from "~/components/open/forms/components/AdvancedFormUrlSettings.vue"
import EmbedFormAsPopupModal from "~/components/pages/forms/show/EmbedFormAsPopupModal.vue"

const workspace = computed(() => useWorkspacesStore().getCurrent)

const props = defineProps({
  form: { type: Object, required: true },
})

definePageMeta({
  middleware: "auth",
})
useOpnSeoMeta({
  title: props.form ? "Share Form - " + props.form.title : "Share Form",
})

const shareFormConfig = ref({
  auto_submit: false,
})

const shareUrlForQueryParams = computed(() => {
  let queryStr = ""
  for (const [key, value] of Object.entries(shareFormConfig.value)) {
    if (value && value !== "false" && value !== false) {
      queryStr +=
        "&" + encodeURIComponent(key) + "=" + encodeURIComponent(value)
    }
  }
  return queryStr.slice(1)
})
</script>
