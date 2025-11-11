import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/services/contact_service.dart';
import 'package:frontend/src/domain/appConfig.dart';
import 'package:frontend/src/features/widgets/bottom_nav.dart';
import 'package:frontend/src/features/transfers/presentation/component/contact_searchbar.dart';
import 'package:frontend/src/features/transfers/presentation/component/contact_item.dart';
import 'package:frontend/src/features/transfers/presentation/component/contact_states.dart';

class ContactListFrame extends HookWidget {
  const ContactListFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final filteredContacts = useState<List<Contact>>([]);
    final allContacts = useState<List<Contact>>([]);
    final isLoading = useState<bool>(true);
    final errorMessage = useState<String?>(null);    final currentIndex = useState(1); 
    final contactService = useMemoized(() => ContactService(baseUrl: AppConfig.baseUrl));
    
    final loadContacts = useCallback(() async {
      try {
        isLoading.value = true;
        errorMessage.value = null;

        final contacts = await contactService.getContacts();
        
        allContacts.value = contacts;
        filteredContacts.value = contacts;
      } catch (e) {
        errorMessage.value = 'Error al cargar contactos: $e';
        allContacts.value = [];
        filteredContacts.value = [];
      } finally {
        isLoading.value = false;
      }
    }, []);

    useEffect(() {
      loadContacts();
      return null;
    }, []);

    useEffect(() {
      final query = searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredContacts.value = allContacts.value;
      } else {
        filteredContacts.value = allContacts.value
            .where((contact) =>
                contact.alias.toLowerCase().contains(query) ||
                contact.name.toLowerCase().contains(query))
            .toList();
      }
      return null;
    }, [searchController.text, allContacts.value]);

    final onContactTap = useCallback((Contact contact) {
      Navigator.pushNamed(
        context,
        '/transfer',
        arguments: contact,
      );
    }, []);

    void handleNavigation(int index) {
      print('ContactListFrame: Navegando a índice $index');
      
      switch (index) {
        case 0:

          Navigator.pop(context);
          break;
        case 1:

          break;
        case 2:

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función de Libreta próximamente'),
              backgroundColor: AppColors.primary,
            ),
          );
          break;
      }
    }    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transferencia a terceros',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [

          ContactSearchBar(
            controller: searchController,
            onChanged: () {
            },
          ),
            // Título de sección
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Contactos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),          
          Expanded(
            child: _buildContactsList(
              filteredContacts.value,
              isLoading.value,
              errorMessage.value,
              onContactTap,
              loadContacts,
            ),
          ),
        ],
      ),      bottomNavigationBar: BottomNav(
        index: currentIndex.value,
        onTap: handleNavigation,
      ),      floatingActionButton: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/add-contact');
              if (result == true) {
                loadContacts();
              }
            },            child: const Icon(
              Icons.person_add,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildContactsList(
    List<Contact> contacts,
    bool isLoading,
    String? errorMessage,
    Function(Contact) onContactTap,
    VoidCallback onRetry,
  ) {
    if (isLoading) {
      return const ContactLoadingState();
    }

    if (errorMessage != null) {
      return ContactErrorState(
        errorMessage: errorMessage,
        onRetry: onRetry,
      );
    }

    if (contacts.isEmpty) {
      return const ContactEmptyState();
    }

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactItem(
            contact: contacts[index],
            onTap: () => onContactTap(contacts[index]),
          );
        },
      ),
    );
  }
}