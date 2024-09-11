<template>
  <div>
    <h2>{{ book.title }}</h2>
    <p>{{ book.author }}</p>
  </div>
</template>
<script>
export default {
  props: {
    book: {
      type: Object,
      required: true
    }
  }
};
</script>
