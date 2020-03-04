export default {
  name: 'venue',
  title: 'Venue',
  type: 'document',
  fields: [
    {
      name: 'name',
      title: 'Name',
      type: 'string'
    },
  ],

  preview: {
    select: {
      title: 'name',
    }
  }
}
