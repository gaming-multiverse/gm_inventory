import InventoryComponent from './components/inventory';
import useNuiEvent from './hooks/useNuiEvent';
import { Items } from './store/items';
import { Locale } from './store/locale';
import { setImagePath } from './store/imagepath';
import { setPlaceItemsEnabled } from './store/placeItems';
import { setTelegramEnabled } from './store/telegram';
import { setupInventory } from './store/inventory';
import { Inventory } from './typings';
import { useAppDispatch } from './store';
import { debugData } from './utils/debugData';
import DragPreview from './components/utils/DragPreview';
import { fetchNui } from './utils/fetchNui';
import { useDragDropManager } from 'react-dnd';
import KeyPress from './components/utils/KeyPress';

debugData([
  {
    action: 'setupInventory',
    data: {
      leftInventory: {
        id: 'test',
        type: 'player',
        slots: 50,
        label: 'Satchel',
        weight: 3000,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'weapon_revolver_lemat',
            weight: 100,
            count: 1,
            metadata: {
              label: 'Russian Cream',
              durability: 10,
            },
          },
          {
            slot: 2,
            name: 'backwoods',
            weight: 100,
            count: 1,
            metadata: {
              label: 'Russian Cream',
              durability: 49,
              imageurl: 'https://i.imgur.com/2xHhTTz.png',
            },
          },
          // {
          //   slot: 3,
          //   name: 'backwoods',
          //   weight: 100,
          //   count: 1,
          //   metadata: {
          //     label: 'Russian Cream',
          //     imageurl: 'https://i.imgur.com/2xHhTTz.png',
          //   },
          // },
          // {
          //   slot: 4,
          //   name: 'backwoods',
          //   weight: 100,
          //   count: 1,
          //   metadata: {
          //     label: 'Russian Cream',
          //     imageurl: 'https://i.imgur.com/2xHhTTz.png',
          //   },
          // },
          // {
          //   slot: 5,
          //   name: 'backwoods',
          //   weight: 100,
          //   count: 1,
          //   metadata: {
          //     label: 'Russian Cream',
          //     imageurl: 'https://i.imgur.com/2xHhTTz.png',
          //   },
          // },
          {
            slot: 6,
            name: 'backwoods',
            weight: 100,
            count: 5,
            metadata: {
              label: 'Russian Cream',
              imageurl: 'https://i.imgur.com/2xHhTTz.png',
            },
          },
        ],
      },
      rightInventory: {
        id: 'player',
        type: 'shop',
        label: 'test',
        slots: 60,
        weight: 3000,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'lockpick',
            weight: 500,
            price: 300,
            ingredients: {
              iron: 5,
              copper: 12,
              powersaw: 0.1,
            },
            metadata: {
              description: 'Simple lockpick that breaks easily and can pick basic door locks',
            },
          },
        ],
      },
    },
  },
]);

const App: React.FC = () => {
  const dispatch = useAppDispatch();
  const manager = useDragDropManager();

  useNuiEvent<{
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
    imagepath: string;
    placeItemsEnabled?: boolean;
    telegramEnabled?: boolean;
  }>('init', ({ locale, items, leftInventory, imagepath, placeItemsEnabled, telegramEnabled }) => {
    for (const name in locale) Locale[name] = locale[name];
    for (const name in items) Items[name] = items[name];

    setImagePath(imagepath);
    setPlaceItemsEnabled(!!placeItemsEnabled);
    setTelegramEnabled(!!telegramEnabled);
    dispatch(setupInventory({ leftInventory }));
  });

  fetchNui('uiLoaded', {});

  useNuiEvent('closeInventory', () => {
    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  return (
    <div className="app-wrapper">
      <InventoryComponent />
      <DragPreview />
      <KeyPress />
    </div>
  );
};

addEventListener("dragstart", function(event) {
  event.preventDefault()
})

export default App;
