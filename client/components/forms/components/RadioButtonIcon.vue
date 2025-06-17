<template>
  <div>
    <Icon
      v-show="isChecked"
      name="ic:round-radio-button-checked"
      class="block"
      :class="[
        theme.FlatSelectInput.icon,
        'bg-[var(--form-color,#09b880)]'
      ]"
    />
    <Icon
      v-show="!isChecked"
      name="ic:round-radio-button-unchecked"
      class="block"
      :class="[
        theme.FlatSelectInput.icon,
        theme.FlatSelectInput.unselectedIcon,
      ]"
    />
  </div>
</template>

<script setup>
defineProps({
  isChecked: {
    type: Boolean,
    required: true
  },
  color: {
    type: String,
    default: ''
  },
  theme: {
    type: Object,
    required: true
  }
})
</script>